Return-Path: <kvm+bounces-56856-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 76D9BB44DF2
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 08:30:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1B1371C23806
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 06:30:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2082529A9E9;
	Fri,  5 Sep 2025 06:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="R2BtP6LF"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2101.outbound.protection.outlook.com [40.107.92.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E85298CDE;
	Fri,  5 Sep 2025 06:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.101
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757053817; cv=fail; b=U1nC0YsH9lJQrb5QfTdN6aAUGXsZlaP6jXahFyuP15C1EGEUAeDWQ2UAEzhtNCBDj2ifUWRItrueEvnfQmRjhKFimN3KjpBa9PCKZDpalZwPSqBWZNEPDSM52G/9Es9yfCfy56tp5SIpHfhppkFG4YxlPA4Avu9z7v+qKDTUIvQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757053817; c=relaxed/simple;
	bh=ou2DgAldHo/fIJNSwlKtOBG7Y5Y/z7xwPY/GHYoRDEk=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=a+s2QX9y07GjUMVEtQ17vDiVRqFXC+a8I9TT0qgOK7Ia2llGWCu06svXaHDgRr22pXMviNmYgkHyqZd6oCRd9KTpEIfJ8ddAdSkzrqwMsK0IBaGgbBlXs1RhAzVSeGpejmSjkHMCBfx+3FT2ziyBpFgiYODbSCip+AXpSRnKJEo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=R2BtP6LF; arc=fail smtp.client-ip=40.107.92.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ir3843tCL/HRrjR5Snz7qv3TaZ2o2KSm/gtRtd2UnZpKV39pGnq6RNFTaISx8P8n3zWc6fCTwRloKrcj2wo83YnT/0LBIya1S473HZBxZuz3T/VMRNGBm/lmY4GYACj2/gT7IKTTsh0NMqJLUmn1r6waWwYAGzy/l4VvFP237Qv+FRPIcUxBPIhNRGGbodx7b1bcKEJduHMeHKMwAB+VQJGdN0ruwjJoiFFHl6wRoGRmPm/619pr+FfRzJXnXu5+1s9jHAp6PCPaSGGQ6NqNL3cCW4HIR+eX0kDFliv5c0p8BDvAQdhbIzn+aGBPNuw9I+wDlouE5mcXJsCBx+SOzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8UQ4Sv5hr+qDXWsY4YVbZSLi/OMElcJ/2IeSdoJbQ9k=;
 b=OSvFYbn4xgjL0GCd7o6nSBkDbonjLGsAVth3Xs7/VzbnBcZouKFO44ywLHEVX3QNFQb4fV2is2O2IG4pPY7OTULFs6t6mrEFuzRPuyR9qPk4UYjbZNYYOPePnciw1AncOqTj2oh0bu1etEXppWYE5pTlqmfCZxI7WGvC0Btomh0xu8MKqOIVWmfV1ScQxVJ2PxJfoFArrmMgADEU0AHT75tfFVlvt89XHsJa+WGT8WrMOkRijmXjSwps07Yy8d24xM97s36HVSfy2nZ5bpy5nd9gBZtihqCx8s52YC5YmpMv8rSA/3CWCdcvL8sY4KKqCfnlRYijfg6Nl1CvG8Xstw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8UQ4Sv5hr+qDXWsY4YVbZSLi/OMElcJ/2IeSdoJbQ9k=;
 b=R2BtP6LF6ZEr8Qh1ca83qWX+iuc4JMyNjHr3kWUvbgadCHBLLet0B1xWLnksALlYZWkvgwZDp2J8XWajrlAorI0nv9/CPBUx733NoXCwSnITrdNcqlbQ5OncZnohDTgyrwxijtp0epJmg2HSARjcujh4aOH8Zb4epss4xwO9Wgs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ2PR01MB8101.prod.exchangelabs.com (2603:10b6:a03:4f6::10) by
 SJ2PR01MB8506.prod.exchangelabs.com (2603:10b6:a03:561::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9073.27; Fri, 5 Sep 2025 06:30:11 +0000
Received: from SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::292:6d9c:eb9a:95c9]) by SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::292:6d9c:eb9a:95c9%2]) with mapi id 15.20.9094.016; Fri, 5 Sep 2025
 06:30:11 +0000
From: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
To: kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: maz@kernel.org,
	oliver.upton@linux.dev,
	darren@os.amperecomputing.com,
	scott@os.amperecomputing.com,
	cl@gentwo.org,
	gankulkarni@os.amperecomputing.com,
	gklkml16@gmail.com
Subject: [PATCH] KVM: arm64: nv: Optimize unmapping of shadow S2-MMU tables
Date: Thu,  4 Sep 2025 23:29:29 -0700
Message-ID: <20250905062929.1741536-1-gankulkarni@os.amperecomputing.com>
X-Mailer: git-send-email 2.50.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR07CA0001.namprd07.prod.outlook.com
 (2603:10b6:610:32::6) To SJ2PR01MB8101.prod.exchangelabs.com
 (2603:10b6:a03:4f6::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR01MB8101:EE_|SJ2PR01MB8506:EE_
X-MS-Office365-Filtering-Correlation-Id: 1cfd4421-b7ce-48b8-a114-08ddec45aa20
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|52116014|376014|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?30PG4SZJiTCsN9of3HIe4gt/G5MwUZY8tO6KU/qIovT27fbVd5ToZtlezIPY?=
 =?us-ascii?Q?F+sorhWeG24FDHw+G6y3jVvz+Gks+BtfwMsXSK7Z0iq7Yz+HFwzcRJhljlSn?=
 =?us-ascii?Q?DXCOO/jrS4G84800IhnXovtQkZJxP2goqH2KAUr8xSI8n1bG0MoYFRqUztuw?=
 =?us-ascii?Q?uaR9z8cbb+bzRmwBC6vZCyUdoRAbelTXdrA6WSlY7dT/2Z2suCXQ5CIcYgRb?=
 =?us-ascii?Q?aqTtMCQFwlIy/RgUAL8foFs9AlIVdwCW9NnB4fdYqpnXgq9lpcDKciz+/4Oi?=
 =?us-ascii?Q?E1rYT+gwnna2BsMV68vdQsj5F/rco6+iA30KWsu5Fc3GD7nF7o/edj/EIjQ/?=
 =?us-ascii?Q?Z9zRphQgtIgSYukLSiPNiPYop5/vvfDF3ipZRzG6oDXhPKepBUkjNa4BNjkq?=
 =?us-ascii?Q?Ra95DKr4dl1Rm3Ng/HinZhx4CmuxYBRoR80dYULSPXAMWX/IlsLPqGO6xGTY?=
 =?us-ascii?Q?D6WqdyrhJsXaLzokKyI5kfFQa3odczrV5wygRyb4VwZfCxp/EoMPiOuZlW5A?=
 =?us-ascii?Q?u3dgtILCSZbbZa2hXuU0atBYxPokj+9q7EXVoWcXlzQwYmtpI0XkVfhJMNAY?=
 =?us-ascii?Q?AFp6w2zQdWET3E1SEQwwm5m2tICFhTnzapH5G0o5X4zvi292EoGXH5zcW2ZU?=
 =?us-ascii?Q?Fog9jgqTOfKsxrN3A/xxvw8ppc1Y6hE47TTA6Vs3+E69NKyf5GFuBkIejL6J?=
 =?us-ascii?Q?Pxsl/4X8NsbmiC3fm2JWy4fNSNkLog+Un1gm3qflgRGACdgvzTEMIVjy6XYM?=
 =?us-ascii?Q?zwunuOY/TcV/g5f6ykZthsMc39nGUc3BDbLzuIkCqcuZQZG09Yk+OZcPZVmA?=
 =?us-ascii?Q?NFBhpsmnuvzUsWNlcQ0HsTuGeC3WJIhJJT1tWAxPnYb98c7FgDSe2wp4JT5w?=
 =?us-ascii?Q?CX5/E55EeAtJQLsO7jyEkXlkb3aTxeBqzewJt2vLY5I1Afkqq9KHrVOwH4Cq?=
 =?us-ascii?Q?ipcKPYMA91O/npdnuSZBDCrdkGpZNwiRv7Dp1uPgYbKurcOOtNp1ep/P/Ypm?=
 =?us-ascii?Q?HqMzaTfcx9mTQPLwoH+pm0S8AqJ9Z2BCLW8eWX07+HBHv6980c5jZFfaVJmz?=
 =?us-ascii?Q?LCJhiJTEi9K0cMaRV9IUCsFVoQl9WivFIKQngWEOZAH7Bn9j/jkZw5a1qHWc?=
 =?us-ascii?Q?Ief3sAXpox7+zS7R3eV2t3amGICA0BnBhqjFfL2VGfHYUPnskQ8ImUcFC/9k?=
 =?us-ascii?Q?7Wy2EqoUrESLXeTU5iGHnD15joKFYwNNBlelXtoh1MPZ8Omletpa4mSAqiUE?=
 =?us-ascii?Q?fPq+ow27X2rpa2yWpGjWshH0njpI1ORMpuQod2RyFGSnHyi7LTXmAN3OcEE9?=
 =?us-ascii?Q?noLszuyX6QCh1s6GRrm+N9/vUxpeBd5806tH3EcG9mYDi6NAaWgInQ83jRhM?=
 =?us-ascii?Q?usndXhawK+mL33J5u4H36XDKD7jNp9rnyHcGlPFPtvbEZayRZ4DgMU2upmzE?=
 =?us-ascii?Q?hncpdA7hIsE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR01MB8101.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(52116014)(376014)(1800799024)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yHm21FgKCyUZNccst0DP5vG5kPHG25BorpsMy3d0+o1PQXTlnEO01bDJObHj?=
 =?us-ascii?Q?CIsYzaPiwiB/93RDyjQscMSG+IHPw1hhO+XP9AeSI+zKPndG1ZtoknA51jGv?=
 =?us-ascii?Q?UEd26A06RdEJHQmcXnxJr9Dzmg6QIUup3t9TtMtf75Z+dBSOvnBmLNUrIu7x?=
 =?us-ascii?Q?wV2BFiGDNQnkMpo5PgkfMjOcUowwkKQ7P1rK7vDj67/Wj0NoLsY1bmAz15xW?=
 =?us-ascii?Q?Wrj6YZ9I8C9tjNZ8U+ecgnm+SEp+GfeUUtD8Z2/+VEVvqycCu3vxakHuNMZE?=
 =?us-ascii?Q?vUDUU1qL+TSRT+T/8MxULhr5Y4afjkMMdmVg/f4EWC425EXdcC5PN+dssI3K?=
 =?us-ascii?Q?tJTqFpXwnrzQqQXB42aob5xYtpVFteX1sdXu6YPvFzglGmVQtBTh+D6TlMOh?=
 =?us-ascii?Q?kMDNK1nbaWER3n6gJypmmL/slkLr6BhLVnQSeEil+JXdUVr+KDX3453cWS9J?=
 =?us-ascii?Q?XcNeGynU7xPjHIN1E58zvHtJ/twdHiVJ2bI3iqRulZ9maDMxavuDGNJfztHd?=
 =?us-ascii?Q?bDMYu7mYif8jdh6nJnFH3QX5RIF2Nz4OYQ/ORuJBuCsFZbieTArU+jZZJ6XB?=
 =?us-ascii?Q?cgrFWpfOJwWaAFiRDf3kTI00SDYzMH8EUVCV+BfPLIhoNzC+8hCVK1Flm/Gr?=
 =?us-ascii?Q?LV9KdNDTXUwL9W3rgJghWX9bNrQbU+9O+vo89azzaiV0FEsq5vILaNw5YSSC?=
 =?us-ascii?Q?6J9pGpT4QqtwQN9IRx2QO94TLAZoxyTx2crDFlRYTkeVyafkkUEfySiZv5sR?=
 =?us-ascii?Q?Ohyoa02/JYEejwIuuFc3jh9DmChdAkKNaGxPxBZEUE9UR0nDD7NXdEG57jjo?=
 =?us-ascii?Q?W8t/QczfGgKqk50mylJtlXczPtCO+DlEfc+WDGg08YwNICSM5TlTim1EYp3P?=
 =?us-ascii?Q?Koj+u+g1DR19sGKoXzXsiIvEScr2o6QRavWopgO/dNb0fvF5gPQbQZ/Mo2tw?=
 =?us-ascii?Q?mA174CXJiP/C9c25d5P5rvTrJVcut4IJ6X/FfgTeezws+qSgQu+2CjikA6aN?=
 =?us-ascii?Q?+KzrwdV1Qarw6E2+TIgI6d/5Xsjq2qAhyFpjsgOvxOXDEhAsjzXXLZTWfvFk?=
 =?us-ascii?Q?695NOfF6Zj2t7LcCeuXC9A+BPTMyAKnr4Z3X+nsAddCkCnfyVIuHbzk0zIMF?=
 =?us-ascii?Q?1DnmSy9vNIidARhzRK8vX3HFITRGyYLW0StxQyli9LiXRe0JGBVvIiaqUTG3?=
 =?us-ascii?Q?2zz6g7dv425s1sMV2aGkZxLCQOMW4NSVfdhtik25RP/AsHftRGqvYCfRvFXJ?=
 =?us-ascii?Q?YtmgrKbFbiecaUBqeaFHDlh4YQd9SFf+yLMaaRnjLqrV9WJlcYRUfdrTUROm?=
 =?us-ascii?Q?fQT3Te8TApLluqz1UGzqKtSOmicsf8F+lMjiuwrloVxZgAV4WNUPRmoZroAk?=
 =?us-ascii?Q?DqF0NJavYkvOXDYnVxDUzvrzd5aHGqTwbAE6+75WKMs1kWH4sVCBZzkDiUNo?=
 =?us-ascii?Q?UsHKE3gNZMs3ccK9SPx4DBiJriSduWQY+rdQRpAZoJku5kaNYBvTf0ag8ZMD?=
 =?us-ascii?Q?ACBv3Cf+kEYANAfetUVFXcapn9SdTHPDta5bYNqO9o1vAUn4R464fg4sY2vy?=
 =?us-ascii?Q?gC1zTJHGtcU+JHon/N76qtoRgDBPQ9FswjcDk0fdYqPazk1agXj4DlSlA2I0?=
 =?us-ascii?Q?8gcKYLf16oAuxUCneV4QykY=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cfd4421-b7ce-48b8-a114-08ddec45aa20
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR01MB8101.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 06:30:11.0159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RzC3BnmGueYAKYMId8VBSspPENFbU+5QfSRL+VzeY8AzzlRnEhXIOWXes9sUTf1Zvf4aM4iiDv3454myxbx+TKj+RJhdUtjxnTKeIdCAnR/We16Odv7aKWIQWsNj7n5b
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR01MB8506

As of commit ec14c272408a ("KVM: arm64: nv: Unmap/flush shadow
stage 2 page tables"), an unmap of a canonical IPA range mapped at L1
triggers invalidation in L1 S2-MMU and in all active shadow (L2) S2-MMU
tables. Because there is no direct mapping to locate the corresponding
shadow IPAs, the code falls back to a full S2-MMU page-table walk and
invalidation across the entire L1 address space.

For 4K pages this causes roughly 256K loop iterations (about 8M for
64K pages) per unmap, which can severely impact performance on large
systems and even cause soft lockups during NV (L1/L2) boots with many
CPUs and large memory. It also causes long delays during L1 reboot.

This patch adds a maple-tree-based lookup that records canonical-IPA to
shadow-IPA mappings whenever a page is mapped into any shadow (L2)
table. On unmap, the lookup is used to target only those shadow IPAs
which are fully or partially mapped in shadow S2-MMU tables, avoiding
a full-address-space walk and unnecessary unmap/flush operations.

The lookup is updated on map/unmap operations so entries remain
consistent with shadow table state. Use it during unmap to invalidate
only affected shadow IPAs, avoiding unnecessary CPU work and reducing
latency when shadow mappings are sparse.

Reviewed-by: Christoph Lameter (Ampere) <cl@gentwo.org>
Signed-off-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
---

Changes since RFC v1:
		Added maple tree based lookup and updated with review
		comments from [1].

[1] https://lkml.indiana.edu/2403.0/03801.html

 arch/arm64/include/asm/kvm_host.h   |   3 +
 arch/arm64/include/asm/kvm_nested.h |   9 +++
 arch/arm64/kvm/mmu.c                |  18 +++--
 arch/arm64/kvm/nested.c             | 102 ++++++++++++++++++++++++++--
 4 files changed, 121 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 2f2394cce24e..eac9405aee48 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -227,6 +227,9 @@ struct kvm_s2_mmu {
 	 * >0: Somebody is actively using this.
 	 */
 	atomic_t refcnt;
+
+	/* For IPA to shadow IPA lookup */
+	struct maple_tree nested_mmu_mt;
 };
 
 struct kvm_arch_memory_slot {
diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 7fd76f41c296..89f91164bc4c 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -69,6 +69,8 @@ extern void kvm_init_nested(struct kvm *kvm);
 extern int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu);
 extern void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu);
 extern struct kvm_s2_mmu *lookup_s2_mmu(struct kvm_vcpu *vcpu);
+extern int add_to_ipa_shadow_ipa_lookup(struct kvm_pgtable *pgt, u64 shadow_ipa, u64 ipa,
+		u64 size);
 
 union tlbi_info;
 
@@ -93,6 +95,12 @@ struct kvm_s2_trans {
 	u64 desc;
 };
 
+struct shadow_ipa_map {
+	u64 shadow_ipa;
+	u64 ipa;
+	u64 size;
+};
+
 static inline phys_addr_t kvm_s2_trans_output(struct kvm_s2_trans *trans)
 {
 	return trans->output;
@@ -130,6 +138,7 @@ extern int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu,
 extern int kvm_inject_s2_fault(struct kvm_vcpu *vcpu, u64 esr_el2);
 extern void kvm_nested_s2_wp(struct kvm *kvm);
 extern void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block);
+extern void kvm_nested_s2_unmap_range(struct kvm *kvm, u64 ipa, u64 size, bool may_block);
 extern void kvm_nested_s2_flush(struct kvm *kvm);
 
 unsigned long compute_tlb_inval_range(struct kvm_s2_mmu *mmu, u64 val);
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1c78864767c5..e9bbc8275a51 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1784,6 +1784,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, fault_ipa, vma_pagesize,
 					     __pfn_to_phys(pfn), prot,
 					     memcache, flags);
+
+		/* Add to lookup, if canonical IPA range mapped to shadow mmu */
+		if (nested)
+			add_to_ipa_shadow_ipa_lookup(pgt, ALIGN_DOWN(fault_ipa, PAGE_SIZE),
+					ipa, vma_pagesize);
 	}
 
 out_unlock:
@@ -1995,14 +2000,15 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 {
+	gpa_t start = range->start << PAGE_SHIFT;
+	gpa_t end = (range->end - range->start) << PAGE_SHIFT;
+	bool may_block = range->may_block;
+
 	if (!kvm->arch.mmu.pgt)
 		return false;
 
-	__unmap_stage2_range(&kvm->arch.mmu, range->start << PAGE_SHIFT,
-			     (range->end - range->start) << PAGE_SHIFT,
-			     range->may_block);
-
-	kvm_nested_s2_unmap(kvm, range->may_block);
+	__unmap_stage2_range(&kvm->arch.mmu, start, end, may_block);
+	kvm_nested_s2_unmap_range(kvm, start, end, may_block);
 	return false;
 }
 
@@ -2280,7 +2286,7 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 
 	write_lock(&kvm->mmu_lock);
 	kvm_stage2_unmap_range(&kvm->arch.mmu, gpa, size, true);
-	kvm_nested_s2_unmap(kvm, true);
+	kvm_nested_s2_unmap_range(kvm, gpa, size, true);
 	write_unlock(&kvm->mmu_lock);
 }
 
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 153b3e11b115..07b7bd3f66fc 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -7,6 +7,7 @@
 #include <linux/bitfield.h>
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
+#include <linux/maple_tree.h>
 
 #include <asm/fixmap.h>
 #include <asm/kvm_arm.h>
@@ -725,6 +726,7 @@ void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu)
 	mmu->tlb_vttbr = VTTBR_CNP_BIT;
 	mmu->nested_stage2_enabled = false;
 	atomic_set(&mmu->refcnt, 0);
+	mt_init_flags(&mmu->nested_mmu_mt, MM_MT_FLAGS);
 }
 
 void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu)
@@ -1067,17 +1069,94 @@ void kvm_nested_s2_wp(struct kvm *kvm)
 	kvm_invalidate_vncr_ipa(kvm, 0, BIT(kvm->arch.mmu.pgt->ia_bits));
 }
 
+/*
+ * Store range of canonical IPA mapped to a nested stage 2 mmu table.
+ * Canonical IPA used as pivot in maple tree for the lookup later
+ * while IPA unmap/flush.
+ */
+int add_to_ipa_shadow_ipa_lookup(struct kvm_pgtable *pgt, u64 shadow_ipa,
+		u64 ipa, u64 size)
+{
+	struct kvm_s2_mmu *mmu;
+	struct shadow_ipa_map *entry;
+	unsigned long start, end;
+
+	start = ipa;
+	end = ipa + size;
+	mmu = pgt->mmu;
+
+	entry = kzalloc(sizeof(struct shadow_ipa_map), GFP_KERNEL_ACCOUNT);
+	entry->ipa = ipa;
+	entry->shadow_ipa = shadow_ipa;
+	entry->size = size;
+	mtree_store_range(&mmu->nested_mmu_mt, start, end - 1, entry,
+			  GFP_KERNEL_ACCOUNT);
+	return 0;
+}
+
+static void mtree_erase_nested(struct maple_tree *mt, unsigned long start,
+		unsigned long size)
+{
+	void *entry = NULL;
+
+	MA_STATE(mas, mt, start, start + size - 1);
+
+	mtree_lock(mt);
+	entry = mas_erase(&mas);
+	mtree_unlock(mt);
+	kfree(entry);
+}
+
+void kvm_nested_s2_unmap_range(struct kvm *kvm, u64 ipa, u64 size,
+		bool may_block)
+{
+	int i;
+	struct shadow_ipa_map *entry;
+	unsigned long start = ipa;
+	unsigned long end = ipa + size;
+
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
+	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
+		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
+
+		if (!kvm_s2_mmu_valid(mmu))
+			continue;
+
+		do {
+			entry = mt_find(&mmu->nested_mmu_mt, &start, end - 1);
+			if (!entry)
+				break;
+
+			kvm_stage2_unmap_range(mmu, entry->shadow_ipa,
+							entry->size, may_block);
+			start = entry->ipa + entry->size;
+			mtree_erase_nested(&mmu->nested_mmu_mt, entry->ipa,
+							entry->size);
+		} while (start < end);
+	}
+}
+
 void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block)
 {
 	int i;
+	unsigned long start = 0;
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
 	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
 		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
+		struct shadow_ipa_map *entry;
 
-		if (kvm_s2_mmu_valid(mmu))
-			kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu), may_block);
+		if (!kvm_s2_mmu_valid(mmu))
+			continue;
+
+		mt_for_each(&mmu->nested_mmu_mt, entry, start, kvm_phys_size(mmu)) {
+			kvm_stage2_unmap_range(mmu, entry->shadow_ipa, entry->size,
+					may_block);
+			kfree(entry);
+		}
+		mtree_destroy(&mmu->nested_mmu_mt);
 	}
 
 	kvm_invalidate_vncr_ipa(kvm, 0, BIT(kvm->arch.mmu.pgt->ia_bits));
@@ -1086,14 +1165,19 @@ void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block)
 void kvm_nested_s2_flush(struct kvm *kvm)
 {
 	int i;
+	unsigned long start = 0;
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
 	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
 		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
+		struct shadow_ipa_map *entry;
 
-		if (kvm_s2_mmu_valid(mmu))
-			kvm_stage2_flush_range(mmu, 0, kvm_phys_size(mmu));
+		if (!kvm_s2_mmu_valid(mmu))
+			continue;
+
+		mt_for_each(&mmu->nested_mmu_mt, entry, start, kvm_phys_size(mmu))
+			kvm_stage2_flush_range(mmu, entry->shadow_ipa, entry->size);
 	}
 }
 
@@ -1737,10 +1821,18 @@ void check_nested_vcpu_requests(struct kvm_vcpu *vcpu)
 {
 	if (kvm_check_request(KVM_REQ_NESTED_S2_UNMAP, vcpu)) {
 		struct kvm_s2_mmu *mmu = vcpu->arch.hw_mmu;
+		unsigned long start = 0;
 
 		write_lock(&vcpu->kvm->mmu_lock);
 		if (mmu->pending_unmap) {
-			kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu), true);
+			struct shadow_ipa_map *entry;
+
+			mt_for_each(&mmu->nested_mmu_mt, entry, start, kvm_phys_size(mmu)) {
+				kvm_stage2_unmap_range(mmu, entry->shadow_ipa, entry->size,
+						true);
+				kfree(entry);
+			}
+			mtree_destroy(&mmu->nested_mmu_mt);
 			mmu->pending_unmap = false;
 		}
 		write_unlock(&vcpu->kvm->mmu_lock);
-- 
2.48.1


