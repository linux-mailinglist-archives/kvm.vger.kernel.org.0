Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06E0B26E0E3
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 18:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728561AbgIQQid (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 12:38:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22150 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728562AbgIQQhv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Sep 2020 12:37:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600360668;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ChLdayVjX8ZWfmVVjxCnF3WKTnlhTghAbOompQAeYzw=;
        b=QFGCBNvcs1LTdZRFKfuDCEgh96FwAuxMUxh7zRFGjxJZj2OYq+dqcHwm/c2PTW3hUKzIzS
        0sK3caYZXhTxxgYQUK4Bi6MSz5/AC8MOfSJ3XCVM3Hp3glvR6VZPLmkMfuETiiM450KIor
        asgE8DwuaNlOkHFsQCS4DQsHScqjezY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-0GYMnudsNWCK5DC6bUlG5g-1; Thu, 17 Sep 2020 12:36:11 -0400
X-MC-Unique: 0GYMnudsNWCK5DC6bUlG5g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BF9AC106B348;
        Thu, 17 Sep 2020 16:36:09 +0000 (UTC)
Received: from work-vm (ovpn-114-108.ams2.redhat.com [10.36.114.108])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4892A6886C;
        Thu, 17 Sep 2020 16:36:04 +0000 (UTC)
Date:   Thu, 17 Sep 2020 17:36:01 +0100
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
Subject: Re: [PATCH v3 1/5] sev/i386: Add initial support for SEV-ES
Message-ID: <20200917163601.GP2793@work-vm>
References: <cover.1600205384.git.thomas.lendacky@amd.com>
 <e2456cc461f329f52aa6eb3fcd0d0ce9451b8fa7.1600205384.git.thomas.lendacky@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2456cc461f329f52aa6eb3fcd0d0ce9451b8fa7.1600205384.git.thomas.lendacky@amd.com>
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
> Co-developed-by: Jiri Slaby <jslaby@suse.cz>
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  target/i386/cpu.c      |  1 +
>  target/i386/sev-stub.c |  5 +++++
>  target/i386/sev.c      | 46 ++++++++++++++++++++++++++++++++++++++++--
>  target/i386/sev_i386.h |  1 +
>  4 files changed, 51 insertions(+), 2 deletions(-)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 588f32e136..bbbe581d35 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -5969,6 +5969,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>          break;
>      case 0x8000001F:
>          *eax = sev_enabled() ? 0x2 : 0;
> +        *eax |= sev_es_enabled() ? 0x8 : 0;

If that also came from a nicely defined constant it would be great.

Other than that;


Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

>          *ebx = sev_get_cbit_position();
>          *ebx |= sev_get_reduced_phys_bits() << 6;
>          *ecx = 0;
> diff --git a/target/i386/sev-stub.c b/target/i386/sev-stub.c
> index 88e3f39a1e..040ac90563 100644
> --- a/target/i386/sev-stub.c
> +++ b/target/i386/sev-stub.c
> @@ -49,3 +49,8 @@ SevCapability *sev_get_capabilities(Error **errp)
>      error_setg(errp, "SEV is not available in this QEMU");
>      return NULL;
>  }
> +
> +bool sev_es_enabled(void)
> +{
> +    return false;
> +}
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index c3ecf86704..6c9cd0854b 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -359,6 +359,12 @@ sev_enabled(void)
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
> @@ -578,6 +584,22 @@ sev_launch_update_data(SevGuestState *sev, uint8_t *addr, uint64_t len)
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
> +        goto err;
> +    }
> +
> +err:
> +    return ret;
> +}
> +
>  static void
>  sev_launch_get_measure(Notifier *notifier, void *unused)
>  {
> @@ -590,6 +612,14 @@ sev_launch_get_measure(Notifier *notifier, void *unused)
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
> @@ -684,7 +714,7 @@ sev_guest_init(const char *id)
>  {
>      SevGuestState *sev;
>      char *devname;
> -    int ret, fw_error;
> +    int ret, fw_error, cmd;
>      uint32_t ebx;
>      uint32_t host_cbitpos;
>      struct sev_user_data_status status = {};
> @@ -745,8 +775,20 @@ sev_guest_init(const char *id)
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
> 2.28.0
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

