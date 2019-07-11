Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98DE4658C7
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 16:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728869AbfGKO2D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 10:28:03 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37516 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728529AbfGKO2C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 10:28:02 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6BEO8Kr001447;
        Thu, 11 Jul 2019 14:26:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=j5hNYpa6Ps4ofAY49xQlyVzas1I7FTDoeSXSCbctYus=;
 b=IZOylVirFWDOmZYSdGDrwFnJwm9CEHLxntE+KdhdKKVzqt1gSAfqZTTsVwqNsGzmUzgE
 PAj74VbhDOsq4BCutkFXYEtKMfHv6uDQN4EwPs/i8mhcZpVyCpdqZIKiMK3B0iniWbhc
 nCHcdwRFI9A6XWvL9fDPRjGkqCOObfWGxfS7XmG6Q9mdYcz4LapWwYkhkHzoQvWylY6M
 ysC+FaRK07kBZ2670+CaYM92TpCurpQy/wzZmTZFtJvwBPFzsFwFvWvwJU5DIkIsFNK3
 zM5EMYBeH4z52ZPL8IQ1EjyFUcZnoz5RUscIoFGUEJ9sBLvHsPC7wF+/3bg5aRqA88yQ 5g== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2tjk2u0e1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Jul 2019 14:26:44 +0000
Received: from achartre-desktop.fr.oracle.com (dhcp-10-166-106-34.fr.oracle.com [10.166.106.34])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x6BEPcuB021444;
        Thu, 11 Jul 2019 14:26:41 GMT
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com, graf@amazon.de,
        rppt@linux.vnet.ibm.com, alexandre.chartre@oracle.com
Subject: [RFC v2 18/26] rcu: Make percpu rcu_data non-static
Date:   Thu, 11 Jul 2019 16:25:30 +0200
Message-Id: <1562855138-19507-19-git-send-email-alexandre.chartre@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
References: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9314 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907110162
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make percpu rcu_data non-static so that it can be mapped into an
isolation address space page-table. This will allow address space
isolation to use RCU without faulting.

Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
---
 kernel/rcu/tree.c |    2 +-
 kernel/rcu/tree.h |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 44dd3b4..2827b2b 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -126,7 +126,7 @@ static void rcu_check_gp_start_stall(struct rcu_node *rnp, struct rcu_data *rdp,
 #define rcu_eqs_special_exit() do { } while (0)
 #endif
 
-static DEFINE_PER_CPU_SHARED_ALIGNED(struct rcu_data, rcu_data) = {
+DEFINE_PER_CPU_SHARED_ALIGNED(struct rcu_data, rcu_data) = {
 	.dynticks_nesting = 1,
 	.dynticks_nmi_nesting = DYNTICK_IRQ_NONIDLE,
 	.dynticks = ATOMIC_INIT(RCU_DYNTICK_CTRL_CTR),
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index 9790b58..a043fde 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -394,3 +394,4 @@ struct rcu_state {
 int rcu_dynticks_snap(struct rcu_data *rdp);
 void call_rcu(struct rcu_head *head, rcu_callback_t func);
 
+DECLARE_PER_CPU_SHARED_ALIGNED(struct rcu_data, rcu_data);
-- 
1.7.1

