Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC7F957A5AE
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 19:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236432AbiGSRqN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 13:46:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235972AbiGSRqM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 13:46:12 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88D25175B0;
        Tue, 19 Jul 2022 10:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658252771; x=1689788771;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=V10jcj6SoywL+fIcMwLbV2Ry4uZy7FI8pB1QjNM89Sg=;
  b=HlbnTXK4+S7URe9obWyaah6BwmMQa9iQEsfFFCAQjapeGf6eUi4+5YId
   xwd2n2pMJQZFjbqiA1Jnd/pIR+/p6tdi3Qxfj85amnGUPKajrBDr1RgNr
   tu0fNxbQSg0bPKxulPMQOPssQoEbvWh9XcpZuQykFCGUnma5s5SRD3B5W
   iV7MzeGKdMYGPV0EqnYJsRItedjt8sxhpu20PZ/pf747sVuW2N0OD1jhq
   qd+qBdqknJJ3QKTKXv0InOm/clSeyFvwz1Ho9RS5yPM/uoT2e8zUhalIm
   qyrQ7tn+ildqebwLlpfAdhT3MITiw2Ie226XRamn6RT2tQGeX5SPZDE6t
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10413"; a="312244422"
X-IronPort-AV: E=Sophos;i="5.92,284,1650956400"; 
   d="scan'208";a="312244422"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 10:46:11 -0700
X-IronPort-AV: E=Sophos;i="5.92,284,1650956400"; 
   d="scan'208";a="687197069"
Received: from twliston-mobl1.amr.corp.intel.com (HELO [10.212.132.190]) ([10.212.132.190])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 10:46:09 -0700
Message-ID: <baaae4b3-7f7d-b193-3546-70170b8b460d@intel.com>
Date:   Tue, 19 Jul 2022 10:46:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v5 02/22] cc_platform: Add new attribute to prevent ACPI
 CPU hotplug
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-acpi@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, thomas.lendacky@amd.com,
        Tianyu.Lan@microsoft.com, rdunlap@infradead.org, Jason@zx2c4.com,
        juri.lelli@redhat.com, mark.rutland@arm.com, frederic@kernel.org,
        yuehaibing@huawei.com, dongli.zhang@oracle.com
References: <cover.1655894131.git.kai.huang@intel.com>
 <f4bff93d83814ea1f54494f51ce3e5d954cf0f5b.1655894131.git.kai.huang@intel.com>
 <43a67bfe-9707-33e0-2574-1e6eca6aa24b@intel.com>
 <5ebd7c3cfb3ab9d77a2577c4864befcffe5359d4.camel@intel.com>
 <173b20166a77012669fdc2c600556fca0623d0b1.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <173b20166a77012669fdc2c600556fca0623d0b1.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/13/22 04:09, Kai Huang wrote:
...
> "TDX doesn’t support adding or removing CPUs from TDX security perimeter. The
> BIOS should prevent CPUs from being hot-added or hot-removed after platform
> boots."

That's a start.  It also probably needs to say that the security
perimeter includes all logical CPUs, though.

>  static int acpi_map_cpu2node(acpi_handle handle, int cpu, int physid)
>  {
> @@ -819,6 +820,12 @@ int acpi_map_cpu(acpi_handle handle, phys_cpuid_t physid,
> u32 acpi_id,
>  {
>         int cpu;
>  
> +       if (platform_tdx_enabled()) {
> +               pr_err("BIOS bug: CPU (physid %u) hot-added on TDX enabled
> platform. Reject it.\n",
> +                               physid);
> +               return -EINVAL;
> +       }

Is this the right place?  There are other sanity checks in
acpi_processor_hotadd_init() and it seems like a better spot.

>         cpu = acpi_register_lapic(physid, acpi_id, ACPI_MADT_ENABLED);
>         if (cpu < 0) {
>                 pr_info("Unable to map lapic to logical cpu number\n");
> @@ -835,6 +842,10 @@ EXPORT_SYMBOL(acpi_map_cpu);
>  
>  int acpi_unmap_cpu(int cpu)
>  {
> +       if (platform_tdx_enabled())
> +               pr_err("BIOS bug: CPU %d hot-removed on TDX enabled platform.
> TDX is broken. Please reboot the machine.\n",
> +                               cpu);
> +
>  #ifdef CONFIG_ACPI_NUMA
>         set_apicid_to_node(per_cpu(x86_cpu_to_apicid, cpu), NUMA_NO_NODE);
>  #endif

