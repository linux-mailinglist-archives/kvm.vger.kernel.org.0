Return-Path: <kvm+bounces-17768-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A6528C9ED6
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 16:34:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5FCB1B2400D
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 14:33:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A9F613774B;
	Mon, 20 May 2024 14:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cyberus-technology.de header.i=@cyberus-technology.de header.b="WB29042Q"
X-Original-To: kvm@vger.kernel.org
Received: from DEU01-FR2-obe.outbound.protection.outlook.com (mail-fr2deu01on2102.outbound.protection.outlook.com [40.107.135.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F071136E26;
	Mon, 20 May 2024 14:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.135.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716215590; cv=fail; b=R9fJzjJ2kenLpnrSdglqJ/46F84/j8v65E5+27JLPU8rViUjOrFNS8zFHKKGNwen4FBQrEGG1WEjLDvi86PBqB5iqW6zJLJZI6TbNTjtfAtyQhyQ4070zVfqUh0AfUhLbsTxS6X9iC4Lx+PBL9KpxxNoS9ZsCeuTcXt8wlMyUbs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716215590; c=relaxed/simple;
	bh=w0jDKZdkhk8OSLlVYpRtwsv7AEf9NIM3S92uHOkJTWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oij7Vf8neO44bT5+wq7vVKV9tdoEm6chPklcoo6l2VDD/kmtogsTF3zMeok7LkHuPAjPSLDJBEuwHH2sfk/GQ7u7IEn5f7FCWZd9f4RG0mCs7NtOH8JGuauhpfMVsqlqSC6LLbwB/zveLZBbDJavJ2ehAwYyZeG4yL/5pf+K6Hs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cyberus-technology.de; spf=pass smtp.mailfrom=cyberus-technology.de; dkim=pass (2048-bit key) header.d=cyberus-technology.de header.i=@cyberus-technology.de header.b=WB29042Q; arc=fail smtp.client-ip=40.107.135.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cyberus-technology.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cyberus-technology.de
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ibmx80cwq0oK9lZ0ghbDK3kZobhmJSIvWtkbjtdVibtFFeu/1XN+L3RjMKCtizQUba4DEMs8LTAse8Qlkp9mWf99wdeI8iTqKnG+NbHn/rFlUiPfvXlDnqq5y6g/SPFJ5+wETaKwojGA9YcgnjgOooBLXkg17Ok8zvz4qxwVGfVoOnSui3vUl4C/pQOo0TYAmlLMx8vJ2TbJIeMSOP+1JDtg/zysk8FVj+YmPGIqNAybGev07XXsEoGIUdkl5lYbbnDp9N7h87zB2LePuuTe9IAt2ihpbboeDaDJpFi+9fgyJ/L/pqXEMyGY7MzLhJpnCpwzoT6AWhfrzasP3u0R1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wZUA/SeEfUnO/dn+cPWISTnH1aU5MZMu0bbtj8icaBQ=;
 b=b+VvHknkHpsOsxLyEs6XsCKe7Rz+UOAzuZHd54OegV1Lv63irKk8WOnOnT5Y4NCMmwyMDIhyc16+pC/pMpJ7jqOEj9QRf6jmjORsKCoTPJBzR0jCp2To7dkXmTx01lp36r8sXB2xNbKu9lCPAh4KEp4AwqC+TQiNxKOvwHmCf7MZAqFNJXLFwZoJaW9ifg4RPXlVeQ7ZSeniORWVYwKWFH6VVsO5fkbPOGYON1R//BxAsTClvEOUTtvRjsyDRcSMkTvz5XFzoeiU98IpkXhRV/x5GhGypuT3KfxZ39SxyjcsZWDjF64+PFer+o6reGt3qOpYsKuGCWpeZrFiq5TPhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cyberus-technology.de; dmarc=pass action=none
 header.from=cyberus-technology.de; dkim=pass header.d=cyberus-technology.de;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cyberus-technology.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wZUA/SeEfUnO/dn+cPWISTnH1aU5MZMu0bbtj8icaBQ=;
 b=WB29042QzBr88/u2BILT0A/ffsyJAgNfvJgsV7K7QoOtQ+KNTDJJeuNXRXWxRAkS7SvLeD/tKgDKCgDYYeTBMWqEAM08V9ki5hxQSQo06fZ6zEX9bjM2Vox20kUAWaSjzBTu8qea6b4UuWhQ2JDGLCrbk/FwVwrG6q4Ry/UneQhab9pEXkv4kObnkEjrVJ4CBx5AArLxofnFXLuN9upGc6phzjaxkj+0JfiyOVPYpQuiff1/JqjK5Pp2O1omz3p6v/SU+V0yGbdo9AGjF91Z40JrYbDKD/HlDZI+GBZMjiHg+SQ/fsC4SHra/xwdRi0Q04m4lpz7fKoV/xJEK2TYeA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cyberus-technology.de;
Received: from FR2P281MB2329.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:38::7) by
 FR6P281MB3534.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:bd::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7611.16; Mon, 20 May 2024 14:33:06 +0000
Received: from FR2P281MB2329.DEUP281.PROD.OUTLOOK.COM
 ([fe80::bf0d:16fc:a18c:c423]) by FR2P281MB2329.DEUP281.PROD.OUTLOOK.COM
 ([fe80::bf0d:16fc:a18c:c423%5]) with mapi id 15.20.7611.013; Mon, 20 May 2024
 14:33:06 +0000
From: Julian Stecklina <julian.stecklina@cyberus-technology.de>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>
Cc: Julian Stecklina <julian.stecklina@cyberus-technology.de>,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] KVM: fix spelling of KVM_RUN_X86_BUS_LOCK in docs
Date: Mon, 20 May 2024 16:32:19 +0200
Message-ID: <20240520143220.340737-2-julian.stecklina@cyberus-technology.de>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240520143220.340737-1-julian.stecklina@cyberus-technology.de>
References: <20240520143220.340737-1-julian.stecklina@cyberus-technology.de>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA3P292CA0009.ESPP292.PROD.OUTLOOK.COM
 (2603:10a6:250:2c::10) To FR2P281MB2329.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:38::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: FR2P281MB2329:EE_|FR6P281MB3534:EE_
X-MS-Office365-Filtering-Correlation-Id: 73641797-fb73-4451-59dc-08dc78d9c39e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|366007|1800799015|52116005|376005|38350700005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tSuAIZMF3CDbRrtKU0xUKHeAzpusDrOm+wrHfummsUHC41j0De5nNpsV2+Be?=
 =?us-ascii?Q?1CNw6gwEh14JzzE/Sbs2nNSddbvW4/Vj2EW8Cgey69baSgihqtMzNw5e+an9?=
 =?us-ascii?Q?ukSQgr0tMx0ivx9utnu2KGew2883DsRTD7HzE+ekQVY4xsI+PeJIP+P1xj3P?=
 =?us-ascii?Q?AoykeKzrg59p4MNBN2Sw/KNd/ysaNMskvP1P9B6VXVeApUbXdU3OjHRW/Pbp?=
 =?us-ascii?Q?WKUV6RHNuuAXG6KUhY3PeNhPLoqvhmkQ2CnAbdzethKeSzJgGCEHGptT1fi2?=
 =?us-ascii?Q?iWJ1EJp5gR24mmHdt0r6Q/9ErxOKuxnb9/JrcZ0uzXYdJ7zDdtC+BbtS081i?=
 =?us-ascii?Q?4hN9dg+65MnEVailytQefswSKW7u7jMapSSlJm78FH2AMPwhsp+/eO8byGNT?=
 =?us-ascii?Q?XDiDJ672xDPzQPZuFYQHxsqJa30fzgfIO+d2lU8YDuQQP5DZTHGS/BkqJs1l?=
 =?us-ascii?Q?wLmXciAvtx8LCHiZ9qftthS2BJAFCX1wmIWNyKohjwUlZ09l1JOoROkhXbkJ?=
 =?us-ascii?Q?93ExSnyAk9tVkYXZ/xKUM0K7NT0SQrfak+JTXHhxtpE0OT0ZBO168hhLh34M?=
 =?us-ascii?Q?j+fEXa6VxFV1D/UGediNvrT6ioTmXcpkhts0EDq613rdV88ucb1ZxCrItqrM?=
 =?us-ascii?Q?SI+pom9io29NyXLgleQssG+qkuvRcGzas5/EM/jWth57fOXYBadV8M9t9erw?=
 =?us-ascii?Q?WEHAnvIBAV+pv6LnFNfFkweAY5fpJUkVMrTY4KC4BLSSRjdeCGpYerD4fx0a?=
 =?us-ascii?Q?M+bvq6evIQm4F6R1h7N96AIkTaPTFs6T7KQIjl7jUkbeaES3F+FgCf81zNPH?=
 =?us-ascii?Q?RBXXhEtVNXlWxNbkiSvH45dYE0wjwzbWIk5487LIekZqGdbktBL+n/adH9mc?=
 =?us-ascii?Q?ZVyG8mlYcZkAP7VqooYto4j7NYBx9lglqoMD1t9TD/fVadT6WkCQuvllygWk?=
 =?us-ascii?Q?6mfZWC4m8TG1isBTeZsDsfqeXNSAp4eWciKhoB/2q+Vs/ZAGZuhg9gCt1pVF?=
 =?us-ascii?Q?RtiXO3dopzsV9twC9Fq46ruvccf1j+a3apxawoa+FYmkUv+azkGUtvu3qn7L?=
 =?us-ascii?Q?ayJ0p7PMEmMrt1sCUDgoBCK0nJrHRuKYf0jo7Da2X/5cItcq3MIebH/NakbW?=
 =?us-ascii?Q?S+OazpXkp52qjNWMUozrFY3N/Xt4o3othH65dESURH5Sz31W7mBKg8pOOOEg?=
 =?us-ascii?Q?yN8h7eGkPt3Xkq+z+5V650MDRJ08mWY0IHUTIm7q3qpuojbxYFlNPgDUeg4d?=
 =?us-ascii?Q?J7xXPyvxOtHGjGqo1XfbvEOmBPkl6o4YJ04fgT3eresuvs82l34pznH7qRvY?=
 =?us-ascii?Q?/WTAhS+A0WIaHSGzA1LrJcsc5NwurmW87GN53OTq3a/24w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:FR2P281MB2329.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(52116005)(376005)(38350700005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BIV6/CKh4m8w0FkjgdvAmpGjS+ee78xA8NnjJKLXADQXVY06GpSHJzntrsyn?=
 =?us-ascii?Q?nMVF7ZCmN0Q6oNFfTTXBjXcEj3h4ScmYZFD9fbFkZr7xOAS3SE67tvAyBZS3?=
 =?us-ascii?Q?bUbo9UuFmBzYqk0HGp3PsT9PKBb2eeYjqEliXCNGYNsqyZw6O9fuJPFK/8yy?=
 =?us-ascii?Q?VtOZhdaV3OFERfJHvZXwkBzVDGhXi54ar8qsAHZhs1zS9V5G0WljGLRz/nEI?=
 =?us-ascii?Q?rZnHbJTo8yKVyQIl2xAcYMWXs5C4GIySGGy4WeSJA6aJRmfmPoOJQ7aPSzBR?=
 =?us-ascii?Q?ZvG844zWdtEUSqaPxpFFOwh3O0Sw8+CythZEvE/4Rz83ZO2mowL/sf6twEdG?=
 =?us-ascii?Q?6Z1xLV8PDdkZvb7P+AUWI2Cyl6APnisJjsNoJ7T5clKWgpA0Unsm8sdXLtLE?=
 =?us-ascii?Q?OSG4qbcHiv2i1+C26eCiff+L3sKN9iq54OB0R839wqC2Ie+o/pnw6/jXMfjp?=
 =?us-ascii?Q?yXnHKX8tRV4SEeSLyZV0I5fXvwDYso/42/va+UFJDmH30eFUOyyIvH2ol2vl?=
 =?us-ascii?Q?jLyZG1cD/LylJCj/+h8UloIma6nA06PUpUUzwNAtJVy1uCWYMkiPubRdBRuO?=
 =?us-ascii?Q?65VF3sHv77J7PnxBzhRCdOfmZ80RhzoriSLsMdnC7MEgnPZIVyLRHP7+T3vR?=
 =?us-ascii?Q?fdR2JbO2sH2193UWQkBZh0M5FWeWEIuzjKjW/IKsMTmaL8PEojYbOyFBkbRZ?=
 =?us-ascii?Q?9O+czaAISyCKyS2DvU6Cf13mRhzztNGPB8KTE6tvYwNo6oZM2minsTALYhPj?=
 =?us-ascii?Q?FQh1G5xQpQAGe9h5iuoJihax90l9YB5bxoHww/oy/QMqpX5uMx4NloQWFjHP?=
 =?us-ascii?Q?eN4KVllho3bnOJ6GBl7E79mC97+MreE2MXvq1dY5G+iCxE9EANJl9aUSpBM+?=
 =?us-ascii?Q?nvdaXfvYiGgSl398BlPUBPWCMMb3PslAV0+8g2d+I+kD4M19GtumtFulkweJ?=
 =?us-ascii?Q?IeAnCGJRCqswuFZXUSCT1K8pJP11PKoEL3reK+63XpRVyMLd8y8pJHoZ0VWA?=
 =?us-ascii?Q?eSz1xf8VLFzifC8KzulAq6g24S41kIlAnsliBq2bqgR2noCNy+dNmqJDAE12?=
 =?us-ascii?Q?spqJvRgs8VyXGHbiNUpoyDOKLcdNtnnTUWLHqV0it21GK1MGyD2zP5UmSIDF?=
 =?us-ascii?Q?/JZ4TBvxjeZiRlfiAkKP+cVQ2jCdEIKJILloMjNTA4DQGH7AwcmKLtXaBl9r?=
 =?us-ascii?Q?+uprOxUSSRPmoKUWoTlohBwCLNc7D4tB8Bb8nepIZG0f7uJD8US/8DVQ8I7e?=
 =?us-ascii?Q?rGlYyGUHAyYU1J3k6F0BRfFtqj97jAJ3z9ZLnlFNeRLweAfQh6qCOyFcJEAd?=
 =?us-ascii?Q?bku6Y3cFPhMtSshUa3SWlzXdNwAdfvE7a6h9zsO7z/o8KI3BGVc63hRWgig+?=
 =?us-ascii?Q?sDbKRRyR9MKxO4WjjUC4XFv+W9aDceQYsrDG1YBJ+Knvh0ZmzvR9TnUo3nY+?=
 =?us-ascii?Q?1Op88gF9ceQURViYwmz3t28VFWDfbljOsm7UqsMtfIDfNytBD7l+dQPLFyVU?=
 =?us-ascii?Q?J8QqpmKJaiAPNaQgiPdrrUFKwwezDxtxuco4x6L4SOaLIOOb5dJoa/Y+IqLo?=
 =?us-ascii?Q?fsiv1/XI6ufLiFnSH1OVicle2BFG2BLFzjJaMvqXkMXxcQ3QUY+ZebDlBgqk?=
 =?us-ascii?Q?6cwXEAqaMmdaJpO8gT2+Ujc=3D?=
X-OriginatorOrg: cyberus-technology.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 73641797-fb73-4451-59dc-08dc78d9c39e
X-MS-Exchange-CrossTenant-AuthSource: FR2P281MB2329.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2024 14:33:06.5824
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f4e0f4e0-9d68-4bd6-a95b-0cba36dbac2e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TwTkD50zDl4q8UIN/2WNCHnnuyrVeMWwC7D3FcIaQFm72UMyXak+szpYLWNJFEXCN7sQO7Fz7kkFcCi3hj3Hev6G/oHe9GZsWdVZMFwHRw2p38nyQ2VFkzC3+AZDkm4k
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR6P281MB3534

The documentation refers to KVM_RUN_BUS_LOCK, but the constant is
actually called KVM_RUN_X86_BUS_LOCK.

Signed-off-by: Julian Stecklina <julian.stecklina@cyberus-technology.de>
---
 Documentation/virt/kvm/api.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 2d45b21b0288..5050535140ab 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6418,7 +6418,7 @@ affect the device's behavior. Current defined flags::
   /* x86, set if the VCPU is in system management mode */
   #define KVM_RUN_X86_SMM     (1 << 0)
   /* x86, set if bus lock detected in VM */
-  #define KVM_RUN_BUS_LOCK    (1 << 1)
+  #define KVM_RUN_X86_BUS_LOCK    (1 << 1)
   /* arm64, set for KVM_EXIT_DEBUG */
   #define KVM_DEBUG_ARCH_HSR_HIGH_VALID  (1 << 0)
 
@@ -7776,10 +7776,10 @@ its own throttling or other policy based mitigations.
 This capability is aimed to address the thread that VM can exploit bus locks to
 degree the performance of the whole system. Once the userspace enable this
 capability and select the KVM_BUS_LOCK_DETECTION_EXIT mode, KVM will set the
-KVM_RUN_BUS_LOCK flag in vcpu-run->flags field and exit to userspace. Concerning
+KVM_RUN_X86_BUS_LOCK flag in vcpu-run->flags field and exit to userspace. Concerning
 the bus lock vm exit can be preempted by a higher priority VM exit, the exit
 notifications to userspace can be KVM_EXIT_BUS_LOCK or other reasons.
-KVM_RUN_BUS_LOCK flag is used to distinguish between them.
+KVM_RUN_X86_BUS_LOCK flag is used to distinguish between them.
 
 7.23 KVM_CAP_PPC_DAWR1
 ----------------------
-- 
2.44.0


