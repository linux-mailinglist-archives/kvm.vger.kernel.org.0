Return-Path: <kvm+bounces-57063-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E763B4A542
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 10:28:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7131A7A3061
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 08:27:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A55B9243367;
	Tue,  9 Sep 2025 08:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QotmK/dV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A668F23C8C5
	for <kvm@vger.kernel.org>; Tue,  9 Sep 2025 08:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757406525; cv=none; b=GThhMDvd6kcQh9Xj2/0ytIpSKjv5AHOR+AhqokOlYxeoUJ7HhwUeU6x3h9JqkZm7ATvhjHslbv73cVNVCrsmxyiYfrLym/oxhuAtwtqYZIV1jgo1jzn2Fzj6v5f0elTasGAJ7x9NoGjt7DZ/EZ2yt2BLm38N6q53E1NE4+a7vhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757406525; c=relaxed/simple;
	bh=jbau4NvScM9WFmrEOaQaZDaL9+RJwNelRI8l9MUAzyQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=XKdZ/FDhfXlDTE6zoyUsNYP+34MY+Xctq/lTY/0zwpUWqhsBPFgI1ddadRCT4zaZYS62ze0IT+ZI/lSqpVEr3p0EMLXLJc6zzQmfHPqOOQyttgUSGWk/zCSRnwrqzmjdI166GyYbpbDlsgV/0oL2X0qs7POQzejOWjs7JlgO4ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=QotmK/dV; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3dad6252eacso2368151f8f.1
        for <kvm@vger.kernel.org>; Tue, 09 Sep 2025 01:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1757406522; x=1758011322; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ts8qPN/5ml6KznKXSDMs1ZerpTtSrzKRDP4paUzXNQE=;
        b=QotmK/dVzQ+6ijf9sGt3pON7Y8K3HoZqW7MT3OAx2CyJi52HaVNuK67GcTXQLPxtC/
         j55xca4hfpQ8kvjActY5MMPyfLkDAvwjX5zqOzj0MboTRCrru0x/gjStrJTJEEUdc0u0
         aJ3tPAvTyyt8Py06DTiKiI4tBq8Lph5/JNOOvwDxxHeEoo/aVsuC/Hw/OQjgbZdIa0qy
         X8NYlyttbjqqnvNk59WPL/Al5bEbxCMnojea4aGvI/nlAy4rwxJZbcdxGRQ1L2HSbUY1
         NzfzQDtDu1BYKqBkk6ZvfKjrAeZqm8aewu2dN/M8nDuo4BbRMbgGFx2oyozDelYiuRQd
         Uofg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757406522; x=1758011322;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ts8qPN/5ml6KznKXSDMs1ZerpTtSrzKRDP4paUzXNQE=;
        b=FseAnWonuM6RuF4eNdYE35T5jEwu2nZVPLXrnXlvGJo3BP6ksy342EIZ4y8/PeJD83
         j9GN5nhy5X2KpEKKnZ49CWM4S9BGI9lb60RnIavWDoJ3cTmvXLmHhsg5CcCbcPO6jNWY
         xu5X+XdTBKTK0PRn48PztG4oG1+8X//vup3QqCdYSkmECHrOZQGbpuwtGADycvVegMNS
         sbNswroj3xbwJbmo19pEZSGBdTsBJAAN8WLRN76HCumAcs+JyZ11HNm/WkKieURGOR0Z
         1rCd1UM55E+ceYKnFoFzWA+lNK/j23VnJ2Thi0E932puNpkYayKq09vgKobrqIofSlAw
         X3/w==
X-Gm-Message-State: AOJu0Yz38JfMyooA5w2OF73zZ4HjW5UADL1C2ssnBlvMCtF1ROeQFszg
	Dxkiab9ZJK3ZqqfaR3IGJ6OlfuTspoYRe6TciPQ3uF16m2CUDoXaPIgDtIeLU9a1lvY=
X-Gm-Gg: ASbGncuZOXoJVg1RfUizcyP/vvXS6D79YEqAs+UiYyytprDK+YMULKwESl+cWE9W/W1
	76aPFFhK6IN9fr9EkKGkwhemEe8dj6b9GrFRzTsBhmeXzsES15QIitFB6JuSPa6LufMNg+AKLdq
	oysvGmqX1kSQ8Ii0AFO2uiD92JoRR/Q/ajtl85RIXTGyDHOrQ3yAt0u9d59BxQvrYPUy8BGKIcX
	xqQB6EPOPgvkll5EV198SE/wxPZKw5mKdJ21yntkbmigAEkqbyobm2Se6vrw7ubow1zUKhH90t+
	N7AskxYbmkVkc/Dz0ImqXnt4yhpykhOm9gabOiN3A1Rnnxa66OW6DJCUvJtarEAAEkM1y7RMH4h
	1t0y5RLSRzRTOvlIYrp7XU/hwMvE=
X-Google-Smtp-Source: AGHT+IEZM9w3N0O4wHGOcaZOsbBh21VHN0Vef/S4rAsCGfvPVxLSsDa77HhbViCTsFwCMFe3kf1qog==
X-Received: by 2002:a05:6000:420e:b0:3c8:7fbf:2d6d with SMTP id ffacd0b85a97d-3e643e0884fmr6910997f8f.50.1757406521848;
        Tue, 09 Sep 2025 01:28:41 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3e7521bfd08sm1639310f8f.4.2025.09.09.01.28.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 01:28:41 -0700 (PDT)
Date: Tue, 9 Sep 2025 11:28:37 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: kvm@vger.kernel.org
Subject: [bug report] KVM: TDX: Get system-wide info about TDX module on
 initialization
Message-ID: <aL_lNXLD3XG496lW@stanley.mountain>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Isaku Yamahata,

Commit 61bb28279623 ("KVM: TDX: Get system-wide info about TDX module
on initialization") from Oct 30, 2024 (linux-next), leads to the
following Smatch static checker warning:

	arch/x86/kvm/vmx/tdx.c:3464 __tdx_bringup()
	warn: missing error code 'r'

arch/x86/kvm/vmx/tdx.c
    3416 static int __init __tdx_bringup(void)
    3417 {
    3418         const struct tdx_sys_info_td_conf *td_conf;
    3419         int r, i;
    3420 
    3421         for (i = 0; i < ARRAY_SIZE(tdx_uret_msrs); i++) {
    3422                 /*
    3423                  * Check if MSRs (tdx_uret_msrs) can be saved/restored
    3424                  * before returning to user space.
    3425                  *
    3426                  * this_cpu_ptr(user_return_msrs)->registered isn't checked
    3427                  * because the registration is done at vcpu runtime by
    3428                  * tdx_user_return_msr_update_cache().
    3429                  */
    3430                 tdx_uret_msrs[i].slot = kvm_find_user_return_msr(tdx_uret_msrs[i].msr);
    3431                 if (tdx_uret_msrs[i].slot == -1) {
    3432                         /* If any MSR isn't supported, it is a KVM bug */
    3433                         pr_err("MSR %x isn't included by kvm_find_user_return_msr\n",
    3434                                 tdx_uret_msrs[i].msr);
    3435                         return -EIO;
    3436                 }
    3437         }
    3438 
    3439         /*
    3440          * Enabling TDX requires enabling hardware virtualization first,
    3441          * as making SEAMCALLs requires CPU being in post-VMXON state.
    3442          */
    3443         r = kvm_enable_virtualization();
    3444         if (r)
    3445                 return r;
    3446 
    3447         cpus_read_lock();
    3448         r = __do_tdx_bringup();
    3449         cpus_read_unlock();
    3450 
    3451         if (r)
    3452                 goto tdx_bringup_err;
    3453 
    3454         /* Get TDX global information for later use */
    3455         tdx_sysinfo = tdx_get_sysinfo();
    3456         if (WARN_ON_ONCE(!tdx_sysinfo)) {
    3457                 r = -EINVAL;
    3458                 goto get_sysinfo_err;
    3459         }
    3460 
    3461         /* Check TDX module and KVM capabilities */
    3462         if (!tdx_get_supported_attrs(&tdx_sysinfo->td_conf) ||
    3463             !tdx_get_supported_xfam(&tdx_sysinfo->td_conf))
--> 3464                 goto get_sysinfo_err;

error code?

    3465 
    3466         if (!(tdx_sysinfo->features.tdx_features0 & MD_FIELD_ID_FEATURES0_TOPOLOGY_ENUM))
    3467                 goto get_sysinfo_err;

here too?

    3468 
    3469         /*
    3470          * TDX has its own limit of maximum vCPUs it can support for all
    3471          * TDX guests in addition to KVM_MAX_VCPUS.  Userspace needs to
    3472          * query TDX guest's maximum vCPUs by checking KVM_CAP_MAX_VCPU
    3473          * extension on per-VM basis.
    3474          *
    3475          * TDX module reports such limit via the MAX_VCPU_PER_TD global
    3476          * metadata.  Different modules may report different values.
    3477          * Some old module may also not support this metadata (in which
    3478          * case this limit is U16_MAX).
    3479          *
    3480          * In practice, the reported value reflects the maximum logical
    3481          * CPUs that ALL the platforms that the module supports can
    3482          * possibly have.
    3483          *
    3484          * Simply forwarding the MAX_VCPU_PER_TD to userspace could
    3485          * result in an unpredictable ABI.  KVM instead always advertise
    3486          * the number of logical CPUs the platform has as the maximum
    3487          * vCPUs for TDX guests.
    3488          *
    3489          * Make sure MAX_VCPU_PER_TD reported by TDX module is not
    3490          * smaller than the number of logical CPUs, otherwise KVM will
    3491          * report an unsupported value to userspace.
    3492          *
    3493          * Note, a platform with TDX enabled in the BIOS cannot support
    3494          * physical CPU hotplug, and TDX requires the BIOS has marked
    3495          * all logical CPUs in MADT table as enabled.  Just use
    3496          * num_present_cpus() for the number of logical CPUs.
    3497          */
    3498         td_conf = &tdx_sysinfo->td_conf;
    3499         if (td_conf->max_vcpus_per_td < num_present_cpus()) {
    3500                 pr_err("Disable TDX: MAX_VCPU_PER_TD (%u) smaller than number of logical CPUs (%u).\n",
    3501                                 td_conf->max_vcpus_per_td, num_present_cpus());
    3502                 r = -EINVAL;
    3503                 goto get_sysinfo_err;
    3504         }
    3505 
    3506         if (misc_cg_set_capacity(MISC_CG_RES_TDX, tdx_get_nr_guest_keyids())) {
    3507                 r = -EINVAL;
    3508                 goto get_sysinfo_err;
    3509         }
    3510 
    3511         /*
    3512          * Leave hardware virtualization enabled after TDX is enabled
    3513          * successfully.  TDX CPU hotplug depends on this.
    3514          */
    3515         return 0;
    3516 
    3517 get_sysinfo_err:
    3518         __tdx_cleanup();
    3519 tdx_bringup_err:
    3520         kvm_disable_virtualization();
    3521         return r;
    3522 }

regards,
dan carpenter

