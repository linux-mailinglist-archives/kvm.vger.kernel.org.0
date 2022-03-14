Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07BE74D8FBC
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 23:43:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245723AbiCNWpD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 18:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245711AbiCNWpB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 18:45:01 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56E6733E8E;
        Mon, 14 Mar 2022 15:43:50 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id t5so16519582pfg.4;
        Mon, 14 Mar 2022 15:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nnjgIKqye+CJXMjwmHEfdNF/5vo11Hu+G8fw/i3NteA=;
        b=ZDIOVAHxzNmdItDQSpovhC+9Kej+KTpY2s0RmH9dULGNbmAtxmlG0u5HCbitiJDMR+
         5SLKeNO3HhXP5l+pTN9QOv8MSBYmIyysCEOOUMtArrONippkVzx9Dsdx/U7SAIIndAST
         WHEPF6jktrKn3ajCB6kWBa6N01j9NVr0Q8cVSVMqYSDq8kNuN5ljNFWnkb2n+1BYTn7Z
         Hn1E1FUt6fNYDINx0MQZXQtkonnKgv62C5teFmfRC4j82iZuQjkRVmFbyjvkoDlVk3zy
         fLrQI8YJvzVll2rOPXxTSaxr7vH0FH4Q6BRUMJJfn89VFkwgD4DKVSprZkHBi397eCcw
         B++Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nnjgIKqye+CJXMjwmHEfdNF/5vo11Hu+G8fw/i3NteA=;
        b=r3e7+pJaB93CpmIEmZp+e397gKvwpmJsiIHJHjfI4ovFqDQbPq0U7EAO/nbLGkRgYV
         fU7yYtq9z97bsRi/XkpitPics8+lqBYDiVcm6dcEz8VIVI1In9dAf+dU3KKihbPIKcFh
         2fuoM8w2Md8Bk1q+fuYrPZ6JkEuDpMMyzDTg6WLAMBWAtguPengyJ2rlQGzfIa7uO1jB
         baT9qwHBm3MSfosltNISOcYnQqUqrHCSd1zEsAvU5J7Dk3ggr2cUtmh9OYK/UXvm8LJ+
         0D+qNJZqbupFzheJrPKZ+5QFXzQk3nbiucthNV9CUaYn5691BB9tNCL3IaPGE5+CqwrQ
         Ioog==
X-Gm-Message-State: AOAM532wl3YzAOTXSND6+xLVwJc2EL1DDElLj2HYv/gz4B7a/skIsQfL
        EbRE7+z9O0a8H6lK0A99kGpSuc+i38VG4g==
X-Google-Smtp-Source: ABdhPJyHyNrsVjP/RGXy4k2gJAQxQD5ZV9C1UNqRsDJy4dPQdspSczQlZ1ka6+E5cX4BYBImKYcU6Q==
X-Received: by 2002:a63:5119:0:b0:37f:8077:ae15 with SMTP id f25-20020a635119000000b0037f8077ae15mr22239079pgb.11.1647297829530;
        Mon, 14 Mar 2022 15:43:49 -0700 (PDT)
Received: from localhost ([192.55.54.52])
        by smtp.gmail.com with ESMTPSA id rm2-20020a17090b3ec200b001bf5647492esm526442pjb.20.2022.03.14.15.43.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 15:43:48 -0700 (PDT)
Date:   Mon, 14 Mar 2022 15:43:46 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Cc:     Dave Hansen <dave.hansen@intel.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        luto@kernel.org, peterz@infradead.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, kirill.shutemov@linux.intel.com,
        hpa@zytor.com, pbonzini@redhat.com, seanjc@google.com,
        srutherford@google.com, ashish.kalra@amd.com,
        darren.kenny@oracle.com, venu.busireddy@oracle.com,
        boris.ostrovsky@oracle.com, isaku.yamahata@gmail.com,
        kvm@vger.kernel.org
Subject: Re: [RFC 0/3] Expose Confidential Computing capabilities on sysfs
Message-ID: <20220314224346.GA3426703@ls.amr.corp.intel.com>
References: <20220309220608.16844-1-alejandro.j.jimenez@oracle.com>
 <8498cff4-3c31-f596-04fe-62013b94d7a4@intel.com>
 <746497ff-992d-4659-aa32-a54c68ae83bf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <746497ff-992d-4659-aa32-a54c68ae83bf@oracle.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Added kvm@vger.kernel.org.

On Thu, Mar 10, 2022 at 01:07:33PM -0500,
Alejandro Jimenez <alejandro.j.jimenez@oracle.com> wrote:

> 
> On 3/9/2022 5:40 PM, Dave Hansen wrote:
> > On 3/9/22 14:06, Alejandro Jimenez wrote:>
> > > On EPYC Milan host:
> > > 
> > > $ grep -r . /sys/kernel/mm/mem_encrypt/*
> > > /sys/kernel/mm/mem_encrypt/c_bit_position:51
> > Why on earth would we want to expose this to userspace?
> > 
> > > /sys/kernel/mm/mem_encrypt/sev/nr_sev_asid:509
> > > /sys/kernel/mm/mem_encrypt/sev/status:enabled
> > > /sys/kernel/mm/mem_encrypt/sev/nr_asid_available:509
> > > /sys/kernel/mm/mem_encrypt/sev_es/nr_sev_es_asid:0
> > > /sys/kernel/mm/mem_encrypt/sev_es/status:enabled
> > > /sys/kernel/mm/mem_encrypt/sev_es/nr_asid_available:509
> > > /sys/kernel/mm/mem_encrypt/sme/status:active
> > For all of this...  What will userspace *do* with it?
> 
> In my case, this information was useful to know for debugging failures when
> testing the various features (e.g. need to specify cbitpos property on QEMU
> sev-guest object).
> 
> It helps get an account of what is currently supported/enabled/active on the
> host/guest, given that some of these capabilities will interact with other
> components and cause boot hangs or errors (e.g. AVIC+SME or AVIC+SEV hangs
> at boot, SEV guests with some configurations need to increase SWIOTLB
> limit).
> 
> The sysfs entry basically answers the questions in
> https://github.com/AMDESE/AMDSEV#faq without needing to run
> virsh/qmp-shell/rdmsr.
> 
> I am aware than having a new sysfs entry mostly to facilitate debugging
> might not be warranted, so I have tagged this as an RFC to ask if others
> working in this space have found additional use cases, or just want the
> convenience of having the data for current and future CoCo features in a
> single location.
> > 
> > For nr_asid_available, I get it.  It tells you how many guests you can
> > still run.  But, TDX will need the same logical thing.  Should TDX hosts
> > go looking for this in:
> > 
> > 	/sys/kernel/mm/mem_encrypt/tdx/available_guest_key_ids
> > 
> > ?
> > 
> > If it's something that's common, it needs to be somewhere common.
> I think it makes sense to have common attributes for all CoCo providers
> under /sys/kernel/mm/mem_encrypt/. The various CoCo providers can create
> entries under mem_encrypt/<feature> exposing the information relevant to
> their specific features like these patches implement for the AMD case, and
> populate or link the <common_attr> attribute with the appropriate value.
> 
> Then we can have:
> 
> /sys/kernel/mm/mem_encrypt/
> -- common_attr
> -- sme/
> -- sev/
> -- sev_es/
> 
> or:
> 
> /sys/kernel/mm/mem_encrypt/
> -- common_attr
> -- tdx/
> 
> Note that at any single time, we are only creating entries that are
> applicable to the hardware we are running on, so there is not a mix of tdx
> and sme/sev subdirs.
> 
> I suspect it will be difficult to agree on what is "common" or even a
> descriptive name. Lets say this common attribute will be:
> 
> ?????? ?????? /sys/kernel/mm/mem_encrypt/common_key
> 
> Where common_key can represent AMD SEV ASIDs/AMD SEV-{ES,SNP} ASIDs, or
> Intel TDX KeyIDs (private/shared), or s390x SEID (Secure Execution IDs), or
> <insert relevant ARM CCA attribute>.
> 
> We can have a (probably long) discussion to agree on the above; this
> patchset just attempts to provide a framework for registering different
> providers, and implements the AMD current capabilities.

The number of available Key IDs (TDX keyid or whatever is called) can be common.
Probably the common misc cgroup is desirable.  I don't see other common thing,
though.  I don't have requirements to expose bit position etc.

TDX requires firmwares which provide information about themselves.  Because
they're firmwares, I'm going to use /sysfs/firmware/tdx.

More concretely
- CPU feature (Secure Arbitration Mode: SEAM) as "seam" flag in /proc/cpuinfo
- TDX firmware(P-SEAMLDR and TDX module) information in /sysfs/firmware/tdx/

What:           /sys/firmware/tdx/
Description:
                Intel's Trust Domain Extensions (TDX) protect guest VMs from
                malicious hosts and some physical attacks.  This directory
                represents the entry point directory for the TDX.

                the TDX requires the TDX firmware to load into an isolated
                memory region.  It requires a two-step loading process.  It uses
                the first phase firmware loader (a.k.a NP-SEAMLDR) that loads
                the next loader and the second phase firmware loader(a.k.a
                P-SEAMLDR) that loads the TDX firmware(a.k.a the "TDX module").
                =============== ================================================
                keyid_num       the number of SEAM keyid as an hexadecimal
                                number with the "0x" prefix.
                =============== ================================================
Users:          libvirt

What:           /sys/firmware/tdx/p_seamldr/
Description:
                The P-SEAMLDR is the TDX module loader. The P-SEAMLDR comes
                with its attributes, vendor_id, build_date, build_num, minor
                version, major version to identify itself.

                Provides the information about the P-SEAMLDR loaded on the
                platform.  This directory exists if the P-SEAMLDR is
                successfully loaded.  It contains the following read-only files.
                The information corresponds to the data structure, SEAMLDR_INFO.
                The admins or VMM management software like libvirt can refer to
                that information, determine if P-SEAMLDR is supported, and
                identify the loaded P-SEAMLDR.

                =============== ================================================
                version         structure version of SEAMLDR_INFO as an
                                hexadecimal number with the "0x" prefix
                                "0x0".
                attributes      32bit flags as a hexadecimal number with the
                                "0x" prefix.
                                Bit 31 - Production-worthy (0) or
                                         debug (1).
                                Bits 30:0 - Reserved 0.
                vendor_id       Vendor ID as a hexadecimal number with the "0x"
                                prefix.
                                "0x0806" (Intel P-SEAMLDR module).
                build_date      Build date in yyyy.mm.dd BCD format.
                build_num       Build number as a hexadecimal number with the
                                "0x" prefix.
                minor           Minor version number as a hexadecimal number
                                with the "0x" prefix.
                major           Major version number as a hexadecimal number
                                with the "0x" prefix.
                seaminfo        The SEAM information of the TDX module currently
                                loaded as binary file.
                seam_ready      A boolean flag that indicates that a debuggable
                                TDX module can be loaded as a hexadecimal number
                                with the "0x" prefix.
                p_seamldr_ready A boolean flag that indicates that the P-SEAMLDR
                                module is ready for SEAMCALLs as a hexadecimal
                                number with the "0x" prefix.
                =============== ================================================
Users:          libvirt

What:           /sys/firmware/tdx/tdx_module/
Description:
                The TDX requires a firmware as known as the TDX module.  It comes
                with its attributes, vendor_id, build_data, build_num,
                minor_version, major_version, etc.

                Provides the information about the TDX module loaded on the
                platform.  It contains the following read-only files.  The
                information corresponds to the data structure, TDSYSINFO_STRUCT.
                The admins or VMM management software like libvirt can refer to
                that information, determine if TDX is supported, and identify
                the loaded the TDX module.

                ================== ============================================
                status             string of the TDX module status.
                                   "unknown"
                                   "none": the TDX module is not loaded
                                   "loaded": The TDX module is loaded, but not
                                             initialized
                                   "initialized": the TDX module is fully
                                                  initialized
                                   "shutdown": the TDX module is shutdown due to
                                               error during initialization.
                attributes         32bit flags of the TDX module attributes as
                                   a hexadecimal number with the "0x" prefix.
                                   Bits 31 - a production module(0) or
                                             a debug module(1).
                                   Bits 30:0 Reserved - set to 0.
                vendor_id          vendor ID as a hexadecimal number with the
                                   "0x" prefix.
                build_date         build date in yyyymmdd BCD format.
                build_num          build number as a hexadecimal number with
                                   the "0x" prefix.
                minor_version      minor version as a hexadecimal number with
                                   the "0x" prefix.
                major_version      major versionas a hexadecimal number with
                                   the "0x" prefix.
                attributes_fixed0  fixed-0 value for TD's attributes as a
                                   hexadecimal number with the "0x" prefix.
                attributes_fixed1  fixed-1 value for TD's attributes as a
                                   hexadecimal number with the "0x" prefix.
                xfam_fixed0        fixed-0 value for TD xfam value as a
                                   hexadecimal number with the "0x" prefix.
                xfam_fixed1        fixed-1 value for TD xfam value as a
                                   hexadecimal number with the "0x" prefix.
                ================== =============================================

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
