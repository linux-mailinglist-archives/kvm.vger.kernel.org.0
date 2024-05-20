Return-Path: <kvm+bounces-17767-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C77C8C9ED2
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 16:33:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CE3C9B23E65
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 14:33:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C06E2136E2B;
	Mon, 20 May 2024 14:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cyberus-technology.de header.i=@cyberus-technology.de header.b="Nm9Yd0Zi"
X-Original-To: kvm@vger.kernel.org
Received: from DEU01-FR2-obe.outbound.protection.outlook.com (mail-fr2deu01on2102.outbound.protection.outlook.com [40.107.135.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F203136E17;
	Mon, 20 May 2024 14:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.135.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716215587; cv=fail; b=seew924c0/vMO0x8b7tY/nyIEKqn6DUsYYLwTz3bdfHczGtMdb/FZY8kCrnfgPiHeTAC+vWIRUo2Wa5FBNCKHTDvc+vTCHMuQ/VAkEdD9ZfEcQd3JRRla1CBubRvmhDzjRGbaTYkgIiSvh1pKyLj0FAGlDGPOv3mxjAfLcHBaAU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716215587; c=relaxed/simple;
	bh=k+77xNoBhvF1nO669QYjxMgTTklNwG7K2Q44tqE00HU=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=cPl919DgA+K8zOD8KRZaM1flE/bbT6dXo/AZK+nua6nm+DWHXKtb9I3rzMvrtFchxEZK4OvGw+Z1+79k2jTucik0lrgUYheE05sGv2UVARNC2w7L8TBYyuqTH3k8pPJX0oFAKly4gT75mk6h55w9jSqApXBQ3tdvaY7E9yYl0Ik=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cyberus-technology.de; spf=pass smtp.mailfrom=cyberus-technology.de; dkim=pass (2048-bit key) header.d=cyberus-technology.de header.i=@cyberus-technology.de header.b=Nm9Yd0Zi; arc=fail smtp.client-ip=40.107.135.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cyberus-technology.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cyberus-technology.de
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X3p6FsWBt4EzKXzjiaVHyxKri7BfSUurr0zxW9Aj6tiIr9AoUHX+MRYPF0S+C8AdHe9fER6W7oNyoFREO7iY8WlZUKO5323lfBjoZgUaUolYEobDU0QKxss+jwJJ93VBKD519tnBCGOW97EdxuG4Bf3a1G3VRLPxjWOlITKQ9SMRcG21NQOVSlnUjX/x0sqMkAi7lBnRReE+Fg+6/mYhTMlNxLXDTGMq+wkV5xPvtmhMeiltPwYvmwetratvxdXCpEVbBpkF3B5KwSrSTNS37EeEa2hL5SDtbscqlNrKDlrRo5ihjBv7jWyN1QA5sdU6yBnrOjuOWeKFp+z2vd196A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rr8XIPm3juejqzASix8DhlwaF2lnzB1WXg9/FMgFXRs=;
 b=XrTlcy46YxmJKO/IciGeoYiJRXNBBf4OFJuoPA/r+gu0ApTe5xOt8FQdAM/Gjw+Yq/Qf6KN1aOShzxDm+klpILYhNKh1oLvq2EaP/D91kwlMVOTZXrE0LyApG/BUNE6BYm9Sl+XV+NQpbFUsUxv0oH2NBMPU7Bx8GDLjaNc/dwiZdcJX6QtdcvF+AepLIYVZXyC7SHPXB/Kz/MJ4YgMyYJLGIAjT7IDnYGGZmAVMCOHJHFmTVJzf3ZpEHxwnsrBoP0cbuyAkrlRznXhvTbiLD+0HZh5mIb+XwzLzZdDRn85pV2Bu7QPbayHeF3+Ep4wf1lELujA3OemDxHoMnmR7cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cyberus-technology.de; dmarc=pass action=none
 header.from=cyberus-technology.de; dkim=pass header.d=cyberus-technology.de;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cyberus-technology.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rr8XIPm3juejqzASix8DhlwaF2lnzB1WXg9/FMgFXRs=;
 b=Nm9Yd0ZiI4vTb7QCQMT/XsdP8s3Z4aGaghKc4Xsi4Z1UC4fRlfoUpbs1GP3jfPrgjL/A3vkkpqD2NS4Mn3PYsdWlJ9WMlQQnejAomAoqLhfcAZ+qiVyqYdCCLvg9p76Ah56jfF9Rz4ujTAkUmlOT3HXBnyqgleGLJnKxByy1Qxoz8ZW/Nrzn6MsbTUCf9paQUv43/gFMFnUj+ajqHI5UbGYJSC93cQRdSNhnajrIlDriOUOdUdhPJwokGXl+naO+5t9gls62gdNp361R+DBCF61NDT1qALZfA9g52WW6QCtPOtjbdddNBgVerfRNKfQlGj2kB8O/Hdl5jTmTd62Rjg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cyberus-technology.de;
Received: from FR2P281MB2329.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:38::7) by
 FR6P281MB3534.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:bd::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7611.16; Mon, 20 May 2024 14:33:00 +0000
Received: from FR2P281MB2329.DEUP281.PROD.OUTLOOK.COM
 ([fe80::bf0d:16fc:a18c:c423]) by FR2P281MB2329.DEUP281.PROD.OUTLOOK.COM
 ([fe80::bf0d:16fc:a18c:c423%5]) with mapi id 15.20.7611.013; Mon, 20 May 2024
 14:32:59 +0000
From: Julian Stecklina <julian.stecklina@cyberus-technology.de>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>
Cc: Julian Stecklina <julian.stecklina@cyberus-technology.de>,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] KVM: fix documentation rendering for KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM
Date: Mon, 20 May 2024 16:32:18 +0200
Message-ID: <20240520143220.340737-1-julian.stecklina@cyberus-technology.de>
X-Mailer: git-send-email 2.44.0
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
X-MS-Office365-Filtering-Correlation-Id: cf5c4b58-e2e8-45d5-3026-08dc78d9bf74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|366007|1800799015|52116005|376005|38350700005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ajiARjLsv9/n/9jg+4vrVgE75waxPE2P+14okrAtaIBHvezwNr9WsJXX6oZs?=
 =?us-ascii?Q?+AO4Bhfy6oVqf+y5y+WJcWtyPcJuK46X5HH/2MlQ3/9SmGd5j+ccZHyx8aVP?=
 =?us-ascii?Q?JrqwMFtwCBGimnmY2g3OG9Yxjtzo1wR7zCq/cgDSCvJ3w+vRdsyHzx2LoYb+?=
 =?us-ascii?Q?sTgABZHKy3/74efdo7BCu9yAevFQHVl1YHfdM1OdUlfESP+YWr/lKb/RQYt5?=
 =?us-ascii?Q?H5pVmwFt6dPv3Z17zAErUbbEq4jgnqHwOQSJc9O5z7MRL+y5rrtf+kio2krI?=
 =?us-ascii?Q?RUP3hg0UQ06uACJsDti+TYO0YPX/+bWvTJ20pax1BYsfuJQRwSm1nPZBJevj?=
 =?us-ascii?Q?KQSIyq32flzs3vk0YfjC9pRqSOagOOBoGMeo1+RJu8+ejsNgJ3ingnSKf1gt?=
 =?us-ascii?Q?ItmxD20VB7xWqUqSprYvegQV91tVFD+dCLyJ7cCDXCvN6MG0jNA/ipz2+JTz?=
 =?us-ascii?Q?D0nKtYDLG8FvGC2IY3U2F7P54VGi2BJxMlERGP3x1wXs1pWQ9nh13MqHxw7V?=
 =?us-ascii?Q?uJuN+S7F3a9J4wHt3vJlu5wYdVRRt3/WfAuQOnnVbi+xX2kNtIaCr9CHy6DP?=
 =?us-ascii?Q?yZWCING/BTvXEH8UMqfmA3NQJQmckBgGHEIFppaLvwa/hAElcSRBZtzICWzo?=
 =?us-ascii?Q?a+8eqju2GGh0tP7MCM7pCGkGEXmBkKv+mOiFN46B5xu1hftLMXlpPhldFJIY?=
 =?us-ascii?Q?slQTxc8tgN7wG3gY6yXAndE8lDSsvWIPzQjV2Gxb38GGWd4b+5+Gcm4/nFMj?=
 =?us-ascii?Q?5APtbGTFCPVgyC3Xa6yQZIkQKQ3ZYaH6DexTDar5uzFK7h5R7ZOQ3AmGMwgN?=
 =?us-ascii?Q?CU535bEIBY6ZR9y3IZLO2YGYsgFYnahI8EOp2W2XS2DK+JSWMttJESPcGhAy?=
 =?us-ascii?Q?1niUnkhGA8CpA6r5JX59Tmg5F+NnNTgyMi9QTk9upwwy+b3TM+I3mVGrSoLN?=
 =?us-ascii?Q?3J+sJsVetLv0zcGBtepIqlR7VrNtTTZG0AJ0jSQzdvZx92UdEsFscNNur8cI?=
 =?us-ascii?Q?CWUgG/+avddF3Dnzys7d0IkFdRlHdNbS+L8/vH/HX1JjUrf1HE1+BEg1PUtF?=
 =?us-ascii?Q?U5ZfmT17AbAMI6cL62xLmjJR6BCyCp17ocKrC/ScBByr+ilX0wvr5ckWGkBD?=
 =?us-ascii?Q?/AlLSiFoAsixdP6wzZGoQc/IPD7sG30wHGtI7nF2yEC2ZKVoeMv2JK4bt3DD?=
 =?us-ascii?Q?kpNmI+prZ9gL8mICG5PVgVYZdnIYV5ybuzevRUYPlorUvlRSNq0teNGvn/qT?=
 =?us-ascii?Q?Sc8VVWaEAnsb5XijNQWH8Og4BFHOo9kbwrwj3I3vXQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:FR2P281MB2329.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(52116005)(376005)(38350700005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cr1JNLSqvZzlZCAONkmYCTdGdcmzEsBtJythftoEFCZ+bTo6V4gicrsfFGEk?=
 =?us-ascii?Q?DJls0Yj5woAN4H3br8y+pbcQfMhhTD3mOsWDa++bm+1a1Rp2sPyH8y2GhJg9?=
 =?us-ascii?Q?vb+wrlyD8jAF8Klh/JiWy8QtglzR2E3Hy9gCVkKqfdNiVuhps4CSe5XF0uum?=
 =?us-ascii?Q?2KcgI0g1FCLSRuMgl/0eM5WOUEsNo75ylHlywzjb/KdUGkh1BpLb8WUIJQuj?=
 =?us-ascii?Q?mQyDZkrU0ZfZOhM1ISML+Kaa14popSNn1UfyNpAddBh7+dq9uI3tjWe3Ni75?=
 =?us-ascii?Q?C/G5vQbYF98ESitxv8ehEga0kY307eIzOu7i+6Z7ji16IWedKsv+9z5fS7CE?=
 =?us-ascii?Q?rjlJ2D+V3HXjHJ/F1OJQ0nnqHlJcFSaXf3HlBf8bGh3eCgN6lLCb2tw0oTkG?=
 =?us-ascii?Q?aRZY7EtQe8kksMKzuFortLAxADBFdBkWd1GfXsc3IeFPYVxoRuaeoCOOObOq?=
 =?us-ascii?Q?k8GviwAmESvfJGz5dsRGcvAg0YJirDs6Ob5XNo5iU8Rgo6hCx2n8XcrQs+OO?=
 =?us-ascii?Q?iTw7sYtHl7/hlsmXq7EV+BfhRv/g0IXqBAUqPtM8TvfcgeGjMevIcOUYJA7F?=
 =?us-ascii?Q?UrvnPgFsSx6gCqHuH9/pcTkZ1sNHYtyOzVNQanlqsVMDjzj1FRXMr8aXi0iK?=
 =?us-ascii?Q?QDRx1fZFaGJAbWlPIveKPQ8hgC2Rs5yszWfzbeh0sG9tLbZ/uLgQPJxkOd+5?=
 =?us-ascii?Q?X2MCOu/krmSaOo+LMAY83wqtPE2AohTAnMDGB0jR2eoRqlkhDd3TQEFtcv1u?=
 =?us-ascii?Q?k0VeEoRRhBKirBVgHfHzkZ8TgYMiI2E8S1jkpjQEXSnM/EZ0clbxFNeBD7hx?=
 =?us-ascii?Q?VYytXoUKxNwRlZbSyoArkK1paf6KUOm0ap3NOOGdMExLOPISAaTyjAY6MqsV?=
 =?us-ascii?Q?5cerrHUmtXxbb4+SPJLI6NcTRV3LFPOyTqFnli1A8fqrBetMbAYftHdc6bya?=
 =?us-ascii?Q?cV1MLTqPEaYXQv1HRHB2psg2+ClMwZK3D4bIuegYnvtjt9XPnbGufi4TF0eo?=
 =?us-ascii?Q?enW++rKMPoym6MZmFlELEVlCHkMyFTLe0q7zZM/xWddLqlFj4hQrkwfPdrIh?=
 =?us-ascii?Q?mdLilZdmWp9xA0q1HSqzR9oPHACc20d4VVCC7Cxt0JfNhxrBTySNK5g+cBtO?=
 =?us-ascii?Q?v9qbgsuG0FJED6Nx4/eWi8PMgKgCPc4b3Wu1VhtsBrZPEssaKn7j/cFCEelt?=
 =?us-ascii?Q?XTUqFJ7wqGTmDwti44D69APkI789xRnAjNPxqxlTZNgJuNrw3L+oBCe4h7pO?=
 =?us-ascii?Q?pGC+Kros2W0fUyDBkUiqo6d/IVOEFbSCnUpg62cMWSD2dhNcDfJiDmGKvlta?=
 =?us-ascii?Q?gkfF7vAPtQivIsEJazl3x/KGnG22gUXnpPYXOeG4Dw1xTReuQInFp+UaGTsx?=
 =?us-ascii?Q?YFKrIcxUm3MVYrnyYYEuic3Vo0AZxqhazCKnKiJiw6t0ZZ51GC3u0RrFGdHr?=
 =?us-ascii?Q?mTfUxGcFs+/yXUdzClQQkmHqqaxsP9jYB9Vs1Rv65hPyybYy0SX4eAVx2AzX?=
 =?us-ascii?Q?MtCvh5p2DpGid1Vc+QCQsUZAxXvWAYYygbyovdNXbhinTAhJxLGGpd0NORmd?=
 =?us-ascii?Q?jW7mQPI2+bXyVM8Nb/CiHzBHK5zHl2kLgND3kRy5fG0xI9tyiSm8duH2XOnD?=
 =?us-ascii?Q?pmc8vJNjRNBVcTwtUy/FDZI=3D?=
X-OriginatorOrg: cyberus-technology.de
X-MS-Exchange-CrossTenant-Network-Message-Id: cf5c4b58-e2e8-45d5-3026-08dc78d9bf74
X-MS-Exchange-CrossTenant-AuthSource: FR2P281MB2329.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2024 14:32:59.7270
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f4e0f4e0-9d68-4bd6-a95b-0cba36dbac2e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9jHBMM/2d9dt3Y7eCHXkWgrQGA62hAtEdUda0LbmjbPF4GfEUXkaFl57QPkYXuY8qpamP/F//I2gfq8frHxBo0Hk/lu9FmOfMh00BcP73AH9FtNoR2MNK99fMPAANH87
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR6P281MB3534

The documentation for KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM doesn't use the
correct keyword formatting, which breaks rendering on
https://www.kernel.org/doc/html/latest/virt/kvm/api.html.

Signed-off-by: Julian Stecklina <julian.stecklina@cyberus-technology.de>
---
 Documentation/virt/kvm/api.rst | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 0b5a33ee71ee..2d45b21b0288 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7895,10 +7895,10 @@ perform a bulk copy of tags to/from the guest.
 7.29 KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM
 -------------------------------------
 
-Architectures: x86 SEV enabled
-Type: vm
-Parameters: args[0] is the fd of the source vm
-Returns: 0 on success
+:Architectures: x86 SEV enabled
+:Type: vm
+:Parameters: args[0] is the fd of the source vm
+:Returns: 0 on success
 
 This capability enables userspace to migrate the encryption context from the VM
 indicated by the fd to the VM this is called on.
-- 
2.44.0


