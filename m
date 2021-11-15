Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E450345183A
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 23:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238945AbhKOWzv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 17:55:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51748 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347055AbhKOWvZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Nov 2021 17:51:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637016461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=toQcFguJghihTlHdbzEa3FVNR9IDFpLArQlk0uC6kXk=;
        b=IKXV1RfxSe1YSMs64k/uLrzYEHVZWJQsJeaonLuK3AKlsfedigF8nFxKaU86flS4iAula1
        vOkgzH+rpoSExkPwkOH3rSYedsLffGnYLX8vaoo66PduJYkOmdaqumoEod0OyDPpjYlNju
        VwPPPPQJIaYCNLb4254TXy7TR3EYrF0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-384-BLKbRg-JOHKPMPzsXuR1HA-1; Mon, 15 Nov 2021 17:47:40 -0500
X-MC-Unique: BLKbRg-JOHKPMPzsXuR1HA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B52F515721;
        Mon, 15 Nov 2021 22:47:39 +0000 (UTC)
Received: from redhat.com (ovpn-114-146.phx2.redhat.com [10.3.114.146])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9CE9019729;
        Mon, 15 Nov 2021 22:47:29 +0000 (UTC)
Date:   Mon, 15 Nov 2021 16:47:27 -0600
From:   Eric Blake <eblake@redhat.com>
To:     Tyler Fanelli <tfanelli@redhat.com>
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com, mtosatti@redhat.com,
        kvm@vger.kernel.org, armbru@redhat.com
Subject: Re: [PATCH] sev: allow capabilities to check for SEV-ES support
Message-ID: <20211115224727.p7g5ydntncvvm5k3@redhat.com>
References: <20211115193804.294529-1-tfanelli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211115193804.294529-1-tfanelli@redhat.com>
User-Agent: NeoMutt/20211029-16-b680fe
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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

Missing '(since 7.0)' tags on the new members.

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

Invalid JSON, as you missed the comma needed after 5.

-- 
Eric Blake, Principal Software Engineer
Red Hat, Inc.           +1-919-301-3266
Virtualization:  qemu.org | libvirt.org

