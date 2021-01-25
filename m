Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0433C3049F1
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 21:20:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732147AbhAZFUd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 00:20:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34408 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726402AbhAYSfw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 Jan 2021 13:35:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611599665;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pprfZIYi/+TC4FwgG2h9TXq3Oe98lmoX25vF+6Tewc0=;
        b=CiQuUdrOuwaAs6LtgtJ6sE+5rtts7bKJTb5bYyhjH3m1qGstP5vXIMRHmdB3inu5IsozTl
        9c8tUEvkVHvDKyuJ92ylMKXGyG7eOSpr3maXj2jHxwuApE/zJ1kYNcrW6CzRa1ctM7t/MD
        D6/OrWmhXAlCincaIGsvp0ktKmpPOdc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-589-e5n-av-NNMucyRD1_ptUrQ-1; Mon, 25 Jan 2021 13:34:21 -0500
X-MC-Unique: e5n-av-NNMucyRD1_ptUrQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D424C8144E2;
        Mon, 25 Jan 2021 18:34:18 +0000 (UTC)
Received: from work-vm (ovpn-114-3.ams2.redhat.com [10.36.114.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3CD2E5C737;
        Mon, 25 Jan 2021 18:34:13 +0000 (UTC)
Date:   Mon, 25 Jan 2021 18:34:10 +0000
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
Subject: Re: [PATCH v5 1/6] sev/i386: Add initial support for SEV-ES
Message-ID: <20210125183410.GO2925@work-vm>
References: <cover.1610665956.git.thomas.lendacky@amd.com>
 <6403cdc0040bc07355b35fe56e26fb9cd11eb172.1610665956.git.thomas.lendacky@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6403cdc0040bc07355b35fe56e26fb9cd11eb172.1610665956.git.thomas.lendacky@amd.com>
User-Agent: Mutt/1.14.6 (2020-07-11)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Tom Lendacky (thomas.lendacky@amd.com) wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> Provide initial support for SEV-ES. This includes creating a function to
> indicate the guest is an SEV-ES guest (which will return false until all
> support is in place), performing the proper SEV initialization and
> ensuring that the guest CPU state is measured as part of the launch.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Richard Henderson <richard.henderson@linaro.org>
> Cc: Eduardo Habkost <ehabkost@redhat.com>
> Co-developed-by: Jiri Slaby <jslaby@suse.cz>
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  target/i386/cpu.c      |  1 +
>  target/i386/sev-stub.c |  6 ++++++
>  target/i386/sev.c      | 44 ++++++++++++++++++++++++++++++++++++++++--
>  target/i386/sev_i386.h |  1 +
>  4 files changed, 50 insertions(+), 2 deletions(-)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 35459a38bb..9adb34c091 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -5986,6 +5986,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>          break;
>      case 0x8000001F:
>          *eax = sev_enabled() ? 0x2 : 0;
> +        *eax |= sev_es_enabled() ? 0x8 : 0;

Yep, matches your docs - it would be great if these magic constants
could become enums or #defines somewhere.

anyway,


Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

>          *ebx = sev_get_cbit_position();
>          *ebx |= sev_get_reduced_phys_bits() << 6;
>          *ecx = 0;
> diff --git a/target/i386/sev-stub.c b/target/i386/sev-stub.c
> index c1fecc2101..229a2ee77b 100644
> --- a/target/i386/sev-stub.c
> +++ b/target/i386/sev-stub.c
> @@ -49,8 +49,14 @@ SevCapability *sev_get_capabilities(Error **errp)
>      error_setg(errp, "SEV is not available in this QEMU");
>      return NULL;
>  }
> +
>  int sev_inject_launch_secret(const char *hdr, const char *secret,
>                               uint64_t gpa, Error **errp)
>  {
>      return 1;
>  }
> +
> +bool sev_es_enabled(void)
> +{
> +    return false;
> +}
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 1546606811..fce2128c07 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -360,6 +360,12 @@ sev_enabled(void)
>      return !!sev_guest;
>  }
>  
> +bool
> +sev_es_enabled(void)
> +{
> +    return false;
> +}
> +
>  uint64_t
>  sev_get_me_mask(void)
>  {
> @@ -580,6 +586,20 @@ sev_launch_update_data(SevGuestState *sev, uint8_t *addr, uint64_t len)
>      return ret;
>  }
>  
> +static int
> +sev_launch_update_vmsa(SevGuestState *sev)
> +{
> +    int ret, fw_error;
> +
> +    ret = sev_ioctl(sev->sev_fd, KVM_SEV_LAUNCH_UPDATE_VMSA, NULL, &fw_error);
> +    if (ret) {
> +        error_report("%s: LAUNCH_UPDATE_VMSA ret=%d fw_error=%d '%s'",
> +                __func__, ret, fw_error, fw_error_to_str(fw_error));
> +    }
> +
> +    return ret;
> +}
> +
>  static void
>  sev_launch_get_measure(Notifier *notifier, void *unused)
>  {
> @@ -592,6 +612,14 @@ sev_launch_get_measure(Notifier *notifier, void *unused)
>          return;
>      }
>  
> +    if (sev_es_enabled()) {
> +        /* measure all the VM save areas before getting launch_measure */
> +        ret = sev_launch_update_vmsa(sev);
> +        if (ret) {
> +            exit(1);
> +        }
> +    }
> +
>      measurement = g_new0(struct kvm_sev_launch_measure, 1);
>  
>      /* query the measurement blob length */
> @@ -686,7 +714,7 @@ sev_guest_init(const char *id)
>  {
>      SevGuestState *sev;
>      char *devname;
> -    int ret, fw_error;
> +    int ret, fw_error, cmd;
>      uint32_t ebx;
>      uint32_t host_cbitpos;
>      struct sev_user_data_status status = {};
> @@ -747,8 +775,20 @@ sev_guest_init(const char *id)
>      sev->api_major = status.api_major;
>      sev->api_minor = status.api_minor;
>  
> +    if (sev_es_enabled()) {
> +        if (!(status.flags & SEV_STATUS_FLAGS_CONFIG_ES)) {
> +            error_report("%s: guest policy requires SEV-ES, but "
> +                         "host SEV-ES support unavailable",
> +                         __func__);
> +            goto err;
> +        }
> +        cmd = KVM_SEV_ES_INIT;
> +    } else {
> +        cmd = KVM_SEV_INIT;
> +    }
> +
>      trace_kvm_sev_init();
> -    ret = sev_ioctl(sev->sev_fd, KVM_SEV_INIT, NULL, &fw_error);
> +    ret = sev_ioctl(sev->sev_fd, cmd, NULL, &fw_error);
>      if (ret) {
>          error_report("%s: failed to initialize ret=%d fw_error=%d '%s'",
>                       __func__, ret, fw_error, fw_error_to_str(fw_error));
> diff --git a/target/i386/sev_i386.h b/target/i386/sev_i386.h
> index 4db6960f60..4f9a5e9b21 100644
> --- a/target/i386/sev_i386.h
> +++ b/target/i386/sev_i386.h
> @@ -29,6 +29,7 @@
>  #define SEV_POLICY_SEV          0x20
>  
>  extern bool sev_enabled(void);
> +extern bool sev_es_enabled(void);
>  extern uint64_t sev_get_me_mask(void);
>  extern SevInfo *sev_get_info(void);
>  extern uint32_t sev_get_cbit_position(void);
> -- 
> 2.30.0
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

