Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39910302B05
	for <lists+kvm@lfdr.de>; Mon, 25 Jan 2021 20:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731453AbhAYTBa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jan 2021 14:01:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31359 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731284AbhAYTAO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 Jan 2021 14:00:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611601127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zHac+loGt9pvJ3ucyE/+rVawDMRHJawcv3rmbk+zyIM=;
        b=KSAEMA5R62EEp6W+Y8EW3kFRzivClLWmMB0WHP+q9cAyfcmVgpwqgnGlz5Gj37K3BMC03Q
        QbY+TVDzQVmXxx35TY0DE+5PQaSwMjMwPbYNZa4/3mYjRIlSMFoCGQlCUkqJ/Ld4v3GIUk
        NVSc9F7QY1S+oiaDmCu9I0UzZ60yn6s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-545-udNWGQvbMD-sYO2gYbaV8A-1; Mon, 25 Jan 2021 13:58:46 -0500
X-MC-Unique: udNWGQvbMD-sYO2gYbaV8A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9C5F58799E0;
        Mon, 25 Jan 2021 18:58:44 +0000 (UTC)
Received: from work-vm (ovpn-114-3.ams2.redhat.com [10.36.114.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0C2AF100AE46;
        Mon, 25 Jan 2021 18:58:38 +0000 (UTC)
Date:   Mon, 25 Jan 2021 18:58:36 +0000
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
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: Re: [PATCH v5 2/6] sev/i386: Require in-kernel irqchip support for
 SEV-ES guests
Message-ID: <20210125185836.GP2925@work-vm>
References: <cover.1610665956.git.thomas.lendacky@amd.com>
 <d959102a84943107c7c2e58d5e2760d2ef4750a9.1610665956.git.thomas.lendacky@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d959102a84943107c7c2e58d5e2760d2ef4750a9.1610665956.git.thomas.lendacky@amd.com>
User-Agent: Mutt/1.14.6 (2020-07-11)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Tom Lendacky (thomas.lendacky@amd.com) wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> In prep for AP booting, require the use of in-kernel irqchip support. This
> lessens the Qemu support burden required to boot APs.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Richard Henderson <richard.henderson@linaro.org>
> Cc: Eduardo Habkost <ehabkost@redhat.com>
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

(I'm failing to fidn a definition of irqchip_required vs allowed)

> ---
>  target/i386/sev.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index fce2128c07..ddec7ebaa7 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -776,6 +776,12 @@ sev_guest_init(const char *id)
>      sev->api_minor = status.api_minor;
>  
>      if (sev_es_enabled()) {
> +        if (!kvm_kernel_irqchip_allowed()) {
> +            error_report("%s: SEV-ES guests require in-kernel irqchip support",
> +                         __func__);
> +            goto err;
> +        }
> +
>          if (!(status.flags & SEV_STATUS_FLAGS_CONFIG_ES)) {
>              error_report("%s: guest policy requires SEV-ES, but "
>                           "host SEV-ES support unavailable",
> -- 
> 2.30.0
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

