Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 432B7452DC0
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 10:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232953AbhKPJVH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 04:21:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:46180 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232764AbhKPJVG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Nov 2021 04:21:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637054289;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=rbfcnZqFpL+HuFS1ZfXm3JBvMoeFE46FPrkhzFUu0S8=;
        b=UU07JxBFrbDWiMTIOQE0ugJCgfuUzWrzd8eX6KU71fzrj5Gghdqn4QDs2FLeAzZluPP+wd
        vCUAUQBF8lV/403SUxux/syuqOqbW2MbxyK1yqkLJP0d0w0k+0QQ5UI38B+IQF4MOtN9IO
        JH8EjUP/6FXJEpob2zt6jqFYvx1SykU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-127-Ppqpds-aPdCozE2pQ_E_8A-1; Tue, 16 Nov 2021 04:18:08 -0500
X-MC-Unique: Ppqpds-aPdCozE2pQ_E_8A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 62FF687D542;
        Tue, 16 Nov 2021 09:18:07 +0000 (UTC)
Received: from redhat.com (unknown [10.33.36.159])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9626668D7D;
        Tue, 16 Nov 2021 09:17:46 +0000 (UTC)
Date:   Tue, 16 Nov 2021 09:17:44 +0000
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Tyler Fanelli <tfanelli@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, mtosatti@redhat.com,
        armbru@redhat.com, pbonzini@redhat.com, eblake@redhat.com
Subject: Re: [PATCH] sev: allow capabilities to check for SEV-ES support
Message-ID: <YZN3OECfHBXd55M5@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20211115193804.294529-1-tfanelli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211115193804.294529-1-tfanelli@redhat.com>
User-Agent: Mutt/2.0.7 (2021-05-04)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 15, 2021 at 02:38:04PM -0500, Tyler Fanelli wrote:
> Probe for SEV-ES and SEV-SNP capabilities to distinguish between Rome,
> Naples, and Milan processors. Use the CPUID function to probe if a
> processor is capable of running SEV-ES or SEV-SNP, rather than if it
> actually is running SEV-ES or SEV-SNP.
> 
> Signed-off-by: Tyler Fanelli <tfanelli@redhat.com>
> ---
>  qapi/misc-target.json | 11 +++++++++--
>  target/i386/sev.c     |  6 ++++--
>  2 files changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/qapi/misc-target.json b/qapi/misc-target.json
> index 5aa2b95b7d..c3e9bce12b 100644
> --- a/qapi/misc-target.json
> +++ b/qapi/misc-target.json
> @@ -182,13 +182,19 @@
>  # @reduced-phys-bits: Number of physical Address bit reduction when SEV is
>  #                     enabled
>  #
> +# @es: SEV-ES capability of the machine.
> +#
> +# @snp: SEV-SNP capability of the machine.
> +#
>  # Since: 2.12
>  ##
>  { 'struct': 'SevCapability',
>    'data': { 'pdh': 'str',
>              'cert-chain': 'str',
>              'cbitpos': 'int',
> -            'reduced-phys-bits': 'int'},
> +            'reduced-phys-bits': 'int',
> +            'es': 'bool',
> +            'snp': 'bool'},
>    'if': 'TARGET_I386' }
>  
>  ##
> @@ -205,7 +211,8 @@
>  #
>  # -> { "execute": "query-sev-capabilities" }
>  # <- { "return": { "pdh": "8CCDD8DDD", "cert-chain": "888CCCDDDEE",
> -#                  "cbitpos": 47, "reduced-phys-bits": 5}}
> +#                  "cbitpos": 47, "reduced-phys-bits": 5
> +#                  "es": false, "snp": false}}

We've previously had patches posted to support SNP in QEMU

  https://lists.gnu.org/archive/html/qemu-devel/2021-08/msg04761.html

and this included an update to query-sev for reporting info
about the VM instance.

Your patch is updating query-sev-capabilities, which is a
counterpart for detecting host capabilities separate from
a guest instance.

None the less I wonder if the same design questions from
query-sev apply. ie do we need to have the ability to
report any SNP specific information fields, if so we need
to use a discriminated union of structs, not just bool
flags.

More generally I'm some what wary of adding this to
query-sev-capabilities at all, unless it is part of the
main SEV-SNP series.

Also what's the intended usage for the mgmt app from just
having these boolean fields ? Are they other more explicit
feature flags we should be reporting, instead of what are
essentially SEV generation codenames.


Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

