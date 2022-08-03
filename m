Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD5B5885D4
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 04:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235407AbiHCChZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 22:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235213AbiHCChY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 22:37:24 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF93C19295;
        Tue,  2 Aug 2022 19:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659494243; x=1691030243;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=NwZXSWxoFI06XNo3KYNX+k/6/v1+eTXuw3wSaDO0CNo=;
  b=THz3EbsxvPSR3ylAQd6dJzbfJGCWkCa49CertntVPns+cntM+N1AXfz8
   ZwTSDc2KseyRSgSKvhHcoaHKtCuTq2Lxy0LgwRP+hR8i+GJv9Nj/+X7hG
   SoNBkdZBp9tBqjPQ2h7YbVnooZt8xsYluosMZYTCEmqhhnwQXB1e6XAic
   Y7OiwaQPnJMELK8uNhHZHmT48o5Fk44dOxQi8nILDv1g/D9fl4eYIKqCP
   k+QEHKu+66OnRd/XhHZLyv7NDZ3x2YilYkSJx5GTuET9gimIwMLcq6z4y
   Xh/i2Z8dhsT1UIxni+H+u4CgvNGMECVofCCjLwysQo7wB5rf/jwQlryy6
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10427"; a="353569275"
X-IronPort-AV: E=Sophos;i="5.93,212,1654585200"; 
   d="scan'208";a="353569275"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2022 19:37:23 -0700
X-IronPort-AV: E=Sophos;i="5.93,212,1654585200"; 
   d="scan'208";a="553152795"
Received: from gvenka2-desk.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.85.17])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2022 19:37:20 -0700
Message-ID: <c96a78c6a8caf25b01e450f139c934688d1735b0.camel@intel.com>
Subject: Re: [PATCH v5 07/22] x86/virt/tdx: Implement SEAMCALL function
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com,
        peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
Date:   Wed, 03 Aug 2022 14:37:18 +1200
In-Reply-To: <0b20f1878d31658a9e3cd3edaf3826fe8731346e.camel@intel.com>
References: <cover.1655894131.git.kai.huang@intel.com>
         <095e6bbc57b4470e1e9a9104059a5238c9775f00.1655894131.git.kai.huang@intel.com>
         <069a062e-a4a6-09af-7b74-7f4929f2ec0b@intel.com>
         <5ce7ebfe54160ea35e432bf50207ebed32db31fc.camel@intel.com>
         <84e93539-a2f9-f68e-416a-ea3d8fc725af@intel.com>
         <6bef368ccc68676e4acaecc4b6dc52f598ea7f2f.camel@intel.com>
         <ea03e55499f556388c0a5f9ed565e72e213c276f.camel@intel.com>
         <978c3d37-97c9-79b9-426a-2c27db34c38a@intel.com>
         <0b20f1878d31658a9e3cd3edaf3826fe8731346e.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-07-21 at 13:52 +1200, Kai Huang wrote:
> Also, if I understand correctly above, your suggestion is we want to prev=
ent any
> CMR memory going offline so it won't be hot-removed (assuming we can get =
CMRs
> during boot).=C2=A0 This looks contradicts to the requirement of being ab=
le to allow
> moving memory from core-mm to driver.=C2=A0 When we offline the memory, w=
e cannot
> know whether the memory will be used by driver, or later hot-removed.

Hi Dave,

The high level flow of device hot-removal is:

acpi_scan_hot_remove()
	-> acpi_scan_try_to_offline()
		-> acpi_bus_offline()
			-> device_offline()
				-> memory_subsys_offline()
	-> acpi_bus_trim()
		-> acpi_memory_device_remove()


And memory_subsys_offline() can also be triggered via /sysfs:

	echo 0 > /sys/devices/system/memory/memory30/online

After the memory block is offline, my understanding is kernel can theoretic=
ally
move it to, i.e. ZONE_DEVICE via memremap_pages().

As you can see memory_subsys_offline() is the entry point of memory device
offline (before it the code is generic for all ACPI device), and it cannot
distinguish whether the removal is from ACPI event, or from /sysfs, so it s=
eems
we are unable to refuse to offline memory in  memory_subsys_offline() when =
it is
called from ACPI event.

Any comments?

--=20
Thanks,
-Kai


