Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60ED06DCADD
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 20:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbjDJSjP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 14:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjDJSjN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 14:39:13 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 002F6E63;
        Mon, 10 Apr 2023 11:39:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1681151954; x=1712687954;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ifwnaQjtcJTBnJ9H9n2iyeoBNX6rxQj0okQWN+DIPS0=;
  b=SN7WWRmyNTYI/nWHhmJBsMiLKvjGq12hiwTOpLfKmroXOzffDx3IW6Fw
   OJg72YD5ixK27+oJiiwigzERqykMK5Zhfpgin2toRsEOgPRq/eCB1xPnT
   wGF0Qds1pip6traj8Y506Z1/y4yZxgORQWvRT9bKB3K4Bvh+GWlBuwFK/
   s=;
X-IronPort-AV: E=Sophos;i="5.98,333,1673913600"; 
   d="scan'208";a="316756763"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-54a853e6.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2023 18:39:10 +0000
Received: from EX19MTAUWA002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-m6i4x-54a853e6.us-east-1.amazon.com (Postfix) with ESMTPS id 7667344E80;
        Mon, 10 Apr 2023 18:39:08 +0000 (UTC)
Received: from EX19D002ANA003.ant.amazon.com (10.37.240.141) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 10 Apr 2023 18:39:00 +0000
Received: from b0f1d8753182.ant.amazon.com.com (10.106.82.21) by
 EX19D002ANA003.ant.amazon.com (10.37.240.141) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 10 Apr 2023 18:38:56 +0000
From:   Takahiro Itazuri <itazur@amazon.com>
To:     <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>, <zulinx86@gmail.com>
Subject: Re: [PATCH] kvm: x86: Update KVM_GET_CPUID2 to return valid entry count
Date:   Mon, 10 Apr 2023 19:38:45 +0100
Message-ID: <20230410183845.98304-1-itazur@amazon.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <ZDQveaSDYx+4z5t4@google.com>
References: <ZDQveaSDYx+4z5t4@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.106.82.21]
X-ClientProxiedBy: EX19D041UWB002.ant.amazon.com (10.13.139.179) To
 EX19D002ANA003.ant.amazon.com (10.37.240.141)
X-Spam-Status: No, score=-2.1 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,T_SPF_PERMERROR
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Date:   Mon, 10 Apr 2023 08:47:05 -0700
From:   Sean Christopherson <seanjc@google.com>
> Capitalize KVM please, i.e. "KVM: x86:".

Will fix. Thanks!

> I think we should break from the (IMO) somewhat funky KVM ioctl() pattern of
> 
> 	r = <errno>
> 	if (try something and it fails)
> 		goto out;
> 
> and instead set "r" in the error paths.  That avoids the need for a scratch "nent",
> and IMO makes this much more straightforward.
> 
> 	int r = 0;
> 
> 	if (cpuid->nent < vcpu->arch.cpuid_nent)
> 		r = -E2BIG;
> 	else if (copy_to_user(entries, vcpu->arch.cpuid_entries,
> 			      vcpu->arch.cpuid_nent * sizeof(struct kvm_cpuid_entry2)))
> 		r = -EFAULT;
> 
> 	/*
> 	 * Update "nent" even on failure, e.g. so that userspace can fix an
> 	 * -E2BIG issue by allocating a larger array.
> 	 */
> 	cpuid->nent = vcpu->arch.cpuid_nent;
> 	return r;

Looks better to me! Will fix this too!.

Best regards,
Takahiro Itazuri

