Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 755A83B40DE
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 11:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbhFYJxF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 05:53:05 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:61456 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231153AbhFYJxE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Jun 2021 05:53:04 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15P9jYfk012370;
        Fri, 25 Jun 2021 09:50:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=Aayt3Djk73VAdvKGtKyXSlGzRn39fXi6kPNxWzN9xGI=;
 b=YH65k0iSrFP/sO420uo+2m05TKx/16Fjv7M1C/9pYWL5e+LX/1ocn0C+xh8obzAXTjom
 mXrXngYrA0Pi8eqScy6vOOTaGMfNmXZkOSUWpvbWdtxHUAUS2uOVNxOlqr/b2fVuScmZ
 igdbAlMcWIFzFRDmgL2YT4M1SRQOkDnBshWd9eVfiUuDTHv4U8bap9/naZkMFWpP/6dP
 2D+Tp+AYqAvs6Ed8/EmCMwq0pv7BjKRoXUnA6F33MKOAcHW5F4y4B5yoIoRPip3F1rJU
 vj0zoV4W9UZM/XGPqhIeFnOXhrQPwSfB0eYLhuW+jgzPqKX4L74IvYFaMy6Hwnp3KOCb Uw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 39d24m10g1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Jun 2021 09:50:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15P9jkdV149024;
        Fri, 25 Jun 2021 09:50:41 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 39d2pxy6tv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Jun 2021 09:50:41 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 15P9of5O159523;
        Fri, 25 Jun 2021 09:50:41 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 39d2pxy6tc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Jun 2021 09:50:41 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.14.4) with ESMTP id 15P9oe4D006840;
        Fri, 25 Jun 2021 09:50:40 GMT
Received: from mwanda (/102.222.70.252)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 25 Jun 2021 09:50:40 +0000
Date:   Fri, 25 Jun 2021 12:50:35 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     bgardon@google.com
Cc:     kvm@vger.kernel.org
Subject: [bug report] KVM: x86/mmu: Skip rmap operations if rmaps not
 allocated
Message-ID: <YNWm623jLRMMDoNS@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-ORIG-GUID: DqLzB9r2youbyi74pRcy9kAI9eTVkRQL
X-Proofpoint-GUID: DqLzB9r2youbyi74pRcy9kAI9eTVkRQL
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Ben Gardon,

The patch e2209710ccc5: "KVM: x86/mmu: Skip rmap operations if rmaps
not allocated" from May 18, 2021, leads to the following static
checker warning:

	arch/x86/kvm/mmu/mmu.c:5704 kvm_mmu_zap_collapsible_sptes()
	error: uninitialized symbol 'flush'.

arch/x86/kvm/mmu/mmu.c
  5687  void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
  5688                                     const struct kvm_memory_slot *memslot)
  5689  {
  5690          /* FIXME: const-ify all uses of struct kvm_memory_slot.  */
  5691          struct kvm_memory_slot *slot = (struct kvm_memory_slot *)memslot;
  5692          bool flush;
                ^^^^^^^^^^
needs to be "bool flush = false;"

  5693  
  5694          if (kvm_memslots_have_rmaps(kvm)) {
  5695                  write_lock(&kvm->mmu_lock);
  5696                  flush = slot_handle_leaf(kvm, slot, kvm_mmu_zap_collapsible_spte, true);
  5697                  if (flush)
  5698                          kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
  5699                  write_unlock(&kvm->mmu_lock);
  5700          }
  5701  
  5702          if (is_tdp_mmu_enabled(kvm)) {
  5703                  read_lock(&kvm->mmu_lock);
  5704                  flush = kvm_tdp_mmu_zap_collapsible_sptes(kvm, slot, flush);
                                                                             ^^^^^
Unintialized.

  5705                  if (flush)
  5706                          kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
  5707                  read_unlock(&kvm->mmu_lock);
  5708          }
  5709  }

regards,
dan carpenter
