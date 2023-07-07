Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E21374B00C
	for <lists+kvm@lfdr.de>; Fri,  7 Jul 2023 13:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232029AbjGGLl3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jul 2023 07:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231950AbjGGLl2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jul 2023 07:41:28 -0400
Received: from smtp-fw-52002.amazon.com (smtp-fw-52002.amazon.com [52.119.213.150])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10D19171D;
        Fri,  7 Jul 2023 04:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1688730087; x=1720266087;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=r4V2ufLUCNsoI97ffmWSoc6qtnrBHBX8sx3vLJWt3JA=;
  b=GB83ByNCMyP5NdmRVx7WBD1l+HhFavzivCwKE3g3aogx0iHvzktwQTu8
   MYXzBPNl5NOV3sp8rr89+tDNPEfxN9cplbdmvPrM8Pq1M8zZWhyZe2gj3
   CG6zxpLbXyIBKCMPvjYtyvlbrABgS2vdZ1r80e6ajLwhOzXxPzA7tfG8B
   0=;
X-IronPort-AV: E=Sophos;i="6.01,187,1684800000"; 
   d="scan'208";a="570858371"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-a893d89c.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-52002.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2023 11:41:24 +0000
Received: from EX19MTAUWA002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-m6i4x-a893d89c.us-west-2.amazon.com (Postfix) with ESMTPS id 10D9C40D4E;
        Fri,  7 Jul 2023 11:41:23 +0000 (UTC)
Received: from EX19D002ANA003.ant.amazon.com (10.37.240.141) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Fri, 7 Jul 2023 11:41:22 +0000
Received: from b0f1d8753182.ant.amazon.com (10.95.106.196) by
 EX19D002ANA003.ant.amazon.com (10.37.240.141) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Fri, 7 Jul 2023 11:41:17 +0000
From:   Takahiro Itazuri <itazur@amazon.com>
To:     Sean Christopherson <seanjc@google.com>,
        Eric Northup <digitaleric@google.com>,
        Eric Northup <digitaleric@gmail.com>,
        Jon Cargille <jcargill@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>, Takahiro Itazuri <zulinx86@gmail.com>,
        Takahiro Itazuri <itazur@amazon.com>
Subject: Re: [PATCH 1/1] KVM: pass through CPUID(0x80000006)
Date:   Fri, 7 Jul 2023 12:41:07 +0100
Message-ID: <20230707114107.73019-1-itazur@amazon.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20200415023726.GD12547@linux.intel.com>
References: <20200415023726.GD12547@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.95.106.196]
X-ClientProxiedBy: EX19D044UWA001.ant.amazon.com (10.13.139.100) To
 EX19D002ANA003.ant.amazon.com (10.37.240.141)
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Please forgive me if this is an absurd question.

Date:   Tue, 14 Apr 2020 19:37:26 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
>   Return the host's L2 cache and TLB information for CPUID.0x80000006
>   instead of zeroing out the entry as part of KVM_GET_SUPPORTED_CPUID.
>   This allows a userspace VMM to feed KVM_GET_SUPPORTED_CPUID's output
>   directly into KVM_SET_CPUID2 (without breaking the guest).

I noticed that CPUID 0x80000005 also returns cache information (L1 Cache
and TLB Information) when looking at AMD APM, while it is marked
reserved on Intel SDM. What do you think about passing through CPUID
0x80000005 to guests?

To be honest, I'm not sure if it is harmless from security and
performance perspectives in the first place.

Regard security aspect, I'm a bit concerned that it could help malicious
guests to know something to allow cache side channel attacks. However,
CPUID 0x80000006 has already passed through L2 Cache and TLB and L3
Cache Information. If passing through CPUID 0x80000006 is really fine,
I'm guessing it is the case with CPUID 0x80000005 as well.

In terms of performance, as far as I know, some softwares utilizes cache
information to achieve better performance. To simply put, by letting
guests know cache information, they may gain some benefits. Having said
that, if I understand correctly, guests can be scheduled on CPUs that do
not belong to the same group of CPUs that they run last time, unless
guests are pinned to a specific set of host physical CPUs. In such
cases, guests may not benefit from using cache information.

If I'm missing something or say something wrong, I'd appreciate it if
you could correct me. If it sounds no problem, I'd like to send a patch
for it.

Best regards,
Takahiro Itazuri

