Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFDA01D37A5
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 19:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726161AbgENRKB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 13:10:01 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:55241 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726035AbgENRKB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 May 2020 13:10:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589476199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KFZ5AjD6loXJYHYKzj8B/hbMmtmyXauXAqQ50TBn0l4=;
        b=PYpUoAevaKyen6xiLC1uHIHG7+6ODtkXNlihtIWW89A2687wPf0EUhXh4hEquWeBvK59mY
        fFULCTjp4oeBo6IhlhM8xDmvedzErnSGk+Zx2QE9IKCKhNZuaHZdbBqLKqJLkqaAP3YbTz
        Mip/kYLN3hAwDEjZkRkB1dJbaPiRpdA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-185-JjzPKOULPFSVs6x4uzB1PQ-1; Thu, 14 May 2020 13:09:55 -0400
X-MC-Unique: JjzPKOULPFSVs6x4uzB1PQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 03AFD108ED68;
        Thu, 14 May 2020 17:09:54 +0000 (UTC)
Received: from work-vm (ovpn-114-247.ams2.redhat.com [10.36.114.247])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D362F1C933;
        Thu, 14 May 2020 17:09:48 +0000 (UTC)
Date:   Thu, 14 May 2020 18:09:46 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     frankja@linux.ibm.com, qemu-devel@nongnu.org,
        brijesh.singh@amd.com, kvm@vger.kernel.org, qemu-ppc@nongnu.org,
        Richard Henderson <rth@twiddle.net>, cohuck@redhat.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        mdroth@linux.vnet.ibm.com
Subject: Re: [RFC 16/18] use errp for gmpo kvm_init
Message-ID: <20200514170808.GS2787@work-vm>
References: <20200514064120.449050-1-david@gibson.dropbear.id.au>
 <20200514064120.449050-17-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514064120.449050-17-david@gibson.dropbear.id.au>
User-Agent: Mutt/1.13.4 (2020-02-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dave:
  You've got some screwy mail headers here, the qemu-devel@nongnu.-rg is
the best one anmd the pair@us.redhat.com is weird as well.

* David Gibson (david@gibson.dropbear.id.au) wrote:
> ---
>  accel/kvm/kvm-all.c                    |  4 +++-
>  include/exec/guest-memory-protection.h |  2 +-
>  target/i386/sev.c                      | 32 +++++++++++++-------------
>  3 files changed, 20 insertions(+), 18 deletions(-)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 5451728425..392ab02867 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -2045,9 +2045,11 @@ static int kvm_init(MachineState *ms)
>      if (ms->gmpo) {
>          GuestMemoryProtectionClass *gmpc =
>              GUEST_MEMORY_PROTECTION_GET_CLASS(ms->gmpo);
> +        Error *local_err = NULL;
>  
> -        ret = gmpc->kvm_init(ms->gmpo);
> +        ret = gmpc->kvm_init(ms->gmpo, &local_err);
>          if (ret < 0) {
> +            error_report_err(local_err);
>              goto err;
>          }
>      }
> diff --git a/include/exec/guest-memory-protection.h b/include/exec/guest-memory-protection.h
> index 7d959b4910..2a88475136 100644
> --- a/include/exec/guest-memory-protection.h
> +++ b/include/exec/guest-memory-protection.h
> @@ -32,7 +32,7 @@ typedef struct GuestMemoryProtection GuestMemoryProtection;
>  typedef struct GuestMemoryProtectionClass {
>      InterfaceClass parent;
>  
> -    int (*kvm_init)(GuestMemoryProtection *);
> +    int (*kvm_init)(GuestMemoryProtection *, Error **);
>      int (*encrypt_data)(GuestMemoryProtection *, uint8_t *, uint64_t);
>  } GuestMemoryProtectionClass;
>  
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 2051fae0c1..82f16b2f3b 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -617,7 +617,7 @@ sev_vm_state_change(void *opaque, int running, RunState state)
>      }
>  }
>  
> -static int sev_kvm_init(GuestMemoryProtection *gmpo)
> +static int sev_kvm_init(GuestMemoryProtection *gmpo, Error **errp)
>  {
>      SevGuestState *sev = SEV_GUEST(gmpo);
>      char *devname;
> @@ -633,14 +633,14 @@ static int sev_kvm_init(GuestMemoryProtection *gmpo)
>      host_cbitpos = ebx & 0x3f;
>  
>      if (host_cbitpos != sev->cbitpos) {
> -        error_report("%s: cbitpos check failed, host '%d' requested '%d'",
> -                     __func__, host_cbitpos, sev->cbitpos);
> +        error_setg(errp, "%s: cbitpos check failed, host '%d' requested '%d'",
> +                   __func__, host_cbitpos, sev->cbitpos);
>          goto err;
>      }
>  
>      if (sev->reduced_phys_bits < 1) {
> -        error_report("%s: reduced_phys_bits check failed, it should be >=1,"
> -                     " requested '%d'", __func__, sev->reduced_phys_bits);
> +        error_setg(errp, "%s: reduced_phys_bits check failed, it should be >=1,"
> +                   " requested '%d'", __func__, sev->reduced_phys_bits);
>          goto err;
>      }
>  
> @@ -649,20 +649,20 @@ static int sev_kvm_init(GuestMemoryProtection *gmpo)
>      devname = object_property_get_str(OBJECT(sev), "sev-device", NULL);
>      sev->sev_fd = open(devname, O_RDWR);
>      if (sev->sev_fd < 0) {
> -        error_report("%s: Failed to open %s '%s'", __func__,
> -                     devname, strerror(errno));
> -    }
> -    g_free(devname);
> -    if (sev->sev_fd < 0) {
> +        g_free(devname);
> +        error_setg(errp, "%s: Failed to open %s '%s'", __func__,
> +                   devname, strerror(errno));
> +        g_free(devname);

You seem to have double free'd devname - would g_autofree work here?

other than that, looks OK to me.

Dave

>          goto err;
>      }
> +    g_free(devname);
>  
>      ret = sev_platform_ioctl(sev->sev_fd, SEV_PLATFORM_STATUS, &status,
>                               &fw_error);
>      if (ret) {
> -        error_report("%s: failed to get platform status ret=%d "
> -                     "fw_error='%d: %s'", __func__, ret, fw_error,
> -                     fw_error_to_str(fw_error));
> +        error_setg(errp, "%s: failed to get platform status ret=%d "
> +                   "fw_error='%d: %s'", __func__, ret, fw_error,
> +                   fw_error_to_str(fw_error));
>          goto err;
>      }
>      sev->build_id = status.build;
> @@ -672,14 +672,14 @@ static int sev_kvm_init(GuestMemoryProtection *gmpo)
>      trace_kvm_sev_init();
>      ret = sev_ioctl(sev->sev_fd, KVM_SEV_INIT, NULL, &fw_error);
>      if (ret) {
> -        error_report("%s: failed to initialize ret=%d fw_error=%d '%s'",
> -                     __func__, ret, fw_error, fw_error_to_str(fw_error));
> +        error_setg(errp, "%s: failed to initialize ret=%d fw_error=%d '%s'",
> +                   __func__, ret, fw_error, fw_error_to_str(fw_error));
>          goto err;
>      }
>  
>      ret = sev_launch_start(sev);
>      if (ret) {
> -        error_report("%s: failed to create encryption context", __func__);
> +        error_setg(errp, "%s: failed to create encryption context", __func__);
>          goto err;
>      }
>  
> -- 
> 2.26.2
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

