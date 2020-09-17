Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37EF026DFED
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 17:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727668AbgIQPnr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 11:43:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55236 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728246AbgIQPnI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Sep 2020 11:43:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600357387;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QZn2aqmg1A+suffaM7wkH0DkVQInOkiyhNGywhMsggA=;
        b=JS4n6o7yh1OA6jQv0fFltC9APWOU0071AwXqP3CeNNVHdWD76lvvXhbB8kcI2Ut4aKmjAD
        PrejfeSlSTeEutetfNrODwr6LFjVBv+OdnmbhLLOaWEVQ4JoAwS1q0oXp+U6xEQ3raHtG2
        nJleQPOZTAZtkF6wvG+NnxzcuOojNBg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-JaTsOvK6OsaXYeb0XxPFkw-1; Thu, 17 Sep 2020 11:34:39 -0400
X-MC-Unique: JaTsOvK6OsaXYeb0XxPFkw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B6F756408F;
        Thu, 17 Sep 2020 15:34:37 +0000 (UTC)
Received: from work-vm (ovpn-114-108.ams2.redhat.com [10.36.114.108])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3B89D73662;
        Thu, 17 Sep 2020 15:34:32 +0000 (UTC)
Date:   Thu, 17 Sep 2020 16:34:29 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Connor Kuehl <ckuehl@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v3 5/5] sev/i386: Enable an SEV-ES guest based on SEV
 policy
Message-ID: <20200917153429.GL2793@work-vm>
References: <cover.1600205384.git.thomas.lendacky@amd.com>
 <8e560a8577066c07b5bf1e5993fbd6d697702384.1600205384.git.thomas.lendacky@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e560a8577066c07b5bf1e5993fbd6d697702384.1600205384.git.thomas.lendacky@amd.com>
User-Agent: Mutt/1.14.6 (2020-07-11)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Tom Lendacky (thomas.lendacky@amd.com) wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> Update the sev_es_enabled() function return value to be based on the SEV
> policy that has been specified. SEV-ES is enabled if SEV is enabled and
> the SEV-ES policy bit is set in the policy object.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  target/i386/sev.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 6ddefc65fa..bcaadaa2f9 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -70,6 +70,8 @@ struct SevGuestState {
>  #define DEFAULT_GUEST_POLICY    0x1 /* disable debug */
>  #define DEFAULT_SEV_DEVICE      "/dev/sev"
>  
> +#define GUEST_POLICY_SEV_ES_BIT (1 << 2)
> +

I'm surprised that all the policy bits aren't defined in a header somewhere.

But other than that,


Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

>  /* SEV Information Block GUID = 00f771de-1a7e-4fcb-890e-68c77e2fb44e */
>  #define SEV_INFO_BLOCK_GUID \
>      "\xde\x71\xf7\x00\x7e\x1a\xcb\x4f\x89\x0e\x68\xc7\x7e\x2f\xb4\x4e"
> @@ -375,7 +377,7 @@ sev_enabled(void)
>  bool
>  sev_es_enabled(void)
>  {
> -    return false;
> +    return sev_enabled() && (sev_guest->policy & GUEST_POLICY_SEV_ES_BIT);
>  }
>  
>  uint64_t
> -- 
> 2.28.0
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

