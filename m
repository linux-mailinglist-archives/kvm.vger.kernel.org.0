Return-Path: <kvm+bounces-66603-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 29962CD81D0
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 06:16:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7B4BB301F00C
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 05:16:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 846982FA0D3;
	Tue, 23 Dec 2025 05:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="AN2ZQoXx";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="G4WThx7l"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BCE52F49F0;
	Tue, 23 Dec 2025 05:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766466319; cv=fail; b=CIJtGzlCpSI44t69AhoADoUB26PpWwHunofDGdYXNw5D4j6AbFvby2VdSMt9LocTfJ0N2HYaipHKZSZG26P6GprfhK31+jTrzjEmsY/YoDOaOUO/JyUwfRpF8VwtexTRyd7d7YGGpeh+o8xmYnl6M8Hgr7nEMgXVoa0ZOfomkTs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766466319; c=relaxed/simple;
	bh=zIC7MfmDfqwBNIxZyy5dDYDmAMCvqg9ZI19Q5OHFp6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kZVMidyZ/r8BytkaMH/+wQrzgM2T769pZw7VFYcFdKgM+WtdRUiCboAN9DwcsR+P6mUKSFyMvQbrvT27YvLyQs6OBTTgv+Nv1ijDKosN3X6T2sCF63W88fD+fTO4Ps2EneKCpkd1BPuqkPo4J/BbiaN+DA83hZ6relNOteBLADE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=AN2ZQoXx; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=G4WThx7l; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BMHLI6r2280199;
	Mon, 22 Dec 2025 21:04:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=JXCiJm8zlx/Nx8gW9iEyffaZLWBG6yAdNp/vBPcUv
	tU=; b=AN2ZQoXxUOLQ+fwYF6YitkHn3jSh4yYIMY+ggj7HBIPldsVhsItxqRnMO
	UzeKC55NTxGsgfF9VqqLYUwXLdEnyZcVfYYPa+YUuwOTGnUbJzhV5m9lvjOh8jQX
	3tFL+7XOykeX+k+RgmjP+htut3XN0801oWaTkY8QZ73W+3p+9LJR1o+eB4embV9C
	HMmMUB2oYgGZA2Cc/F1gUDocjujiRoKpdPgG9OyWm+WzMOX8sLwdouGm+I+LAc4r
	xRK4CAYW9vgyXO84ax8eBm1z/nEk0PS4DwdT4R9GS7npXcChFRDzhX8idT53dx0B
	5+HvbvygGjmwgrzhh8BK0zjznHU4w==
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11020139.outbound.protection.outlook.com [52.101.61.139])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4b5v7yvuvt-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 21:04:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dUZLiuAQtTanTEpo43EJ7A+jig1A4l6s33pVw/Cr2FWaMpkp6SuZd4Kdm+d0pxGmfkqUCruJDN06hD+GG5Mc0687hfStj0AEWv8BG4mf6viOAS4c7YPJ5gcBB+hmZJy3FFxZgyEJdWPYxokLYn6nPmVaUfzHCVmKmMwGleDTIFiyye28m0HtHLLkwsBVXQm7Y2iKXm9dYDZTVs12AdAGwsMuWc88wEKG8PyYuaNZvqwZZOlDwk2MMUZifuGgSrFjyaRF6CIFuML+Zjei2e54R0V7szV3mXwmlFB7k+DwN42PUJoZNhvcxn9qVDfuuSK2CY7XTKI0j4ZERdnqceaYSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JXCiJm8zlx/Nx8gW9iEyffaZLWBG6yAdNp/vBPcUvtU=;
 b=AzMZIXx6OPDBW1q+ZRFwmwaLJhhLos55OEVU58Qq8KKfdqjNS0epVK7+Qvkvlsn5QR9xLurJwMjk9Yhlh+uCrKH+eYTExT2Zjym4LcBYo5b0ftWE8njPhTSPII8hV1ZuutTOyVRgPn8/iyN3MdFA9gJKu7nkVK+3rMbrFlSvQzt/VCVg9f+P9Rv9Gqq3D8C/4keeXB0cTI9b90xFhymcB4PKwDk4VsUQFDcO2/YHnkUzYsf7aftQ6ZzmyiD98DTgcS3fnqqMz+I2b/urkixZklHE6/D+eWIDDv376OJVOAIKEM5ArtB/zzvFdadN+pSfEcgMUAlKk/WGrsyvjmPhdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JXCiJm8zlx/Nx8gW9iEyffaZLWBG6yAdNp/vBPcUvtU=;
 b=G4WThx7l7l9/gITtzOPOgM0U0mfUN9u1y/VwWTmLq/oi/N84Z/raPtM/0yUQpexFbgyegNRobAeIbzoQZNS8ADL9PE1tcJqTpvD2JKE2s2cUECv0A5fzhtLcJff9s8BkkoSJD9Ue5pWMWa409EUj8+YP+Sf0z7GJZKAMcp0q/Kc/Q0VwPBgZ7+LDzUgCfVB0hfIKcX63m1GwFZi/km2/c5726cztFUpLP5U96D6JvV5YTm/9W/6g4HcJ+rUTvV24VHf5mQV20WQcq12dTBZse3AhHZtg77orHx7JVn/oGbQ3zEC32k8xe1fnXhG9MgQMEcf77JVi7besmQZM57hiKg==
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18) by SA1PR02MB8560.namprd02.prod.outlook.com
 (2603:10b6:806:1fb::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.11; Tue, 23 Dec
 2025 05:04:36 +0000
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc]) by LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc%4]) with mapi id 15.20.9434.009; Tue, 23 Dec 2025
 05:04:34 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: ken@codelabs.ch, Alexander.Grest@microsoft.com, chao.gao@intel.com,
        madvenka@linux.microsoft.com, mic@digikod.net, nsaenz@amazon.es,
        tao1.su@linux.intel.com, xiaoyao.li@intel.com, zhao1.liu@intel.com,
        Jon Kohler <jon@nutanix.com>
Subject: [PATCH 6/8] KVM: VMX: enhance EPT violation handler for MBEC
Date: Mon, 22 Dec 2025 22:47:59 -0700
Message-ID: <20251223054806.1611168-7-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251223054806.1611168-1-jon@nutanix.com>
References: <20251223054806.1611168-1-jon@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0P220CA0016.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::19) To LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV0PR02MB11133:EE_|SA1PR02MB8560:EE_
X-MS-Office365-Filtering-Correlation-Id: 621d769c-c76b-4007-cd49-08de41e0c3ec
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|1800799024|376014|7416014|366016|921020|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XAthW9aEXMiEWDYAzsbL+yfzGzaHZS9zUAEHFWXMZwQK8RL9HqUT8OQ16tis?=
 =?us-ascii?Q?AV231KfGcJzA9sPEEgWSv7pKObFgtmJJqfpTvEHK4tUI8TokPYSPu/xeJ3pR?=
 =?us-ascii?Q?Gw9dLHZ/BpbcrsLfsFzOMdkMcCtQWpVxoITz4NH19Pq+hKFUAhdwG8TpByMo?=
 =?us-ascii?Q?KeKjFEnknfeTEsmJSCdxxB3JfXu8TBkKpJkDY0dNVPa5n8qmwCjymCmJ4nfx?=
 =?us-ascii?Q?r0uS4+VEQ0gGML4LX2kmLF4i8AVuwU6cTVX0JP8LwEd9BTskB8scOcMun3qw?=
 =?us-ascii?Q?XNXK1XeW+Xr+hs0AAH7srIDfRULZk46c327yIMmhhc1jegONPLlNg1dcp2bs?=
 =?us-ascii?Q?7sWNIAqbAFjrqNvksi6xlURafX9g1dQ3BAjOjGE8HZBMpHn9dd8A32VkJILj?=
 =?us-ascii?Q?k1fGW/lFqAGHzuPg4LITiEYDtLZcjemdmVcMYwk/yBCxb91Br7HtleRLrg6p?=
 =?us-ascii?Q?G1VpOkDaTjOlHEa1DWDIBErLYlZVIGv0CemVEVJVgk15M1LbgSZuBpBhWF0R?=
 =?us-ascii?Q?jh9vDxaLYH6gdRGlSKz8obbtFPwCEUsHwA7/yAyq4dGeApfUJesT3IChAZkx?=
 =?us-ascii?Q?G2yJRlA1eLCIYt/GnX4VlnIN5mApZPlQsYyAitA+HDxdJf1CnJejQqW5T2Fz?=
 =?us-ascii?Q?cMWs276djM3ttKQHQKT/LKSG3mnevcRX8SqRKCipUYFLV9Se61iomH4f4Eq5?=
 =?us-ascii?Q?+6LAAXF4jTmpN2DkDo4uVVTP7Ey3QerukiAaYAIRx6rLo106mfOUjxG4+ChZ?=
 =?us-ascii?Q?xQAzdgdwFkIqBAOLot8lZFXanbTeClCy3S6hrIYliQ+Z0DOPKyuhuWJ0oEfR?=
 =?us-ascii?Q?Gb/u2yeJQvhxZ0/u09Ox72gUZS/lRhptNNXTTinu7RDN1PGI7NSKtH0G6V5m?=
 =?us-ascii?Q?LKSb4b5ldFvq9ZTZL6Xwul+q8a28sDN9TQjiap2sGmlNUoESWktxmq67gCh2?=
 =?us-ascii?Q?kyiYJsNwA96Liq65klLsPCLWjI8hbnQ/7hR6oIx528glOWt1OC59iSwsfxC6?=
 =?us-ascii?Q?hzzE+2GOe2Q5Oir33pyVEstCWetHV20ogi2dfA4pSepz8Bi1hzyGROaPnnsu?=
 =?us-ascii?Q?/me3TuitFj7k4nTVy+f4A5eW/k38IfNXlywkPnfmBo7nST1Izdh+Zkj7dAYn?=
 =?us-ascii?Q?1K5jVyY+8BiQdtZ0zM3r6VQSAnnQwlT5K337evRz4o+TuPCWy1pyWMqrraRT?=
 =?us-ascii?Q?pcYuIBaBUm0kXyHH4xNd6I7iO0c9nj17IQ2ML5MNS8oS+OhWgwMv//qTQfI/?=
 =?us-ascii?Q?y2OcJ8+sG2zwq7RYd+elkmBzjg5MwMrTD/ENs4sjqtF0lkqeuaBBj9uLsDLd?=
 =?us-ascii?Q?iUEWnH72obhTOwO9ekgZvdkdUbUHaTzWWwiurcTyabF52zW9sU9oiFt1ZwPG?=
 =?us-ascii?Q?CGhYkyELYDtyAbuUIeLY+36AggLbJVuGlXGDisPF+7NPHiguh2WHL3aMw0e0?=
 =?us-ascii?Q?9p8F5OSKFRVE03p9pOZi3mW9mt5nSYnTKxd/rpTMpdhsip/u26Ll0ixiQ0h/?=
 =?us-ascii?Q?B3MInLqmE9IXSIhMkhV6klBMNps2cr1vdZkWaHZNiyc4HIevHpbqV/wWpA?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR02MB11133.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(1800799024)(376014)(7416014)(366016)(921020)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fGGqZwN/Mqu3SeTN79WM1LVHKoFUd8WUA1i07DVpI6wV3WHb8uF42xR4Az/b?=
 =?us-ascii?Q?2vQp2KZzlJxObAY3wgDUqw30ivlaUTqOYzgTvEL8Lu6deKiUbG5mOSxcUlYz?=
 =?us-ascii?Q?4pZeJj06NPrhUN98egtlsM7Ib2aqFuMLUbX/noiJpI8LHmm6kVrePLABac4r?=
 =?us-ascii?Q?9KJF4an7clJExUQqNTwS/8Gk3+UE9Gqk/0JDNP2UZP0gesoOfXOLVOzp2tPM?=
 =?us-ascii?Q?5OS+RsqFL6tKywVAsGxbd1hzid4ufN0Kh7xLYQhoSCANpTpjzctdBpTIQOom?=
 =?us-ascii?Q?qwjdpmYRNvOOopm/vbQERufh0mP3x21qhgo5bJneex+FnnwQVK8CrkkCj3uZ?=
 =?us-ascii?Q?hWEGHPybMvluWevn6Q5PM6r2Eoep4vlqWPbIJMX9GXz1z9n1GNmGcMwbnR36?=
 =?us-ascii?Q?YoPHHhfT0baRYIm9x44rPtUES5joRDxnVddWEOZz4hlNL70qMRTrnejAbxjA?=
 =?us-ascii?Q?RGTtlNk/IcAIBCrLNqFPcYlvcbGgrFZ7CSQEJbZ3X9IeXw5JHwpQEn03CsR7?=
 =?us-ascii?Q?zDgIkzVc1JTXzKz3ai44wTXwgyHhV63o2TxiNHjjqMpCtl1Wn/epfoMwaVvd?=
 =?us-ascii?Q?5yfQF5F7/4x86/LehW7AIV4MXWThvPBqdbyF1O3rv1DXrQF1LxvXlcwIiLnf?=
 =?us-ascii?Q?XXUvvSij7tZ3fbDW2KSeS55KRaibpVaeqtrS5/Qny8ads0QjCD+UAro2jZKt?=
 =?us-ascii?Q?mBx0gQ6sXe5bXB1kLaf7peyHtVk3Yc83Qm9wSBVCVtFAaUrAbZBf/kO/eWpB?=
 =?us-ascii?Q?bHNr2BBJSGqWG6oUwvCL0tbH7UAyTZjjc7WU28XGlPH5IW24mMEn2Tamxyuo?=
 =?us-ascii?Q?MH5k+iQgBdqZJNTDR8WoQMJhNtxOdCxF9A5nrXC5OpYtr+AIyCBrsyh0fJfP?=
 =?us-ascii?Q?ZEWX1z2ac9dtLQZX7g7oVIBc/TeGbNAmP8SlbMm3zUy/40hU7tm8muVo6Zhb?=
 =?us-ascii?Q?wJ/DeNBOeBvYt9JWBsGrvGK4Gx6Wq0z2U5s5O9ZSCvtY0L2cmyyFDX+alA9t?=
 =?us-ascii?Q?u7+Onpt4qwV+nUz5uY/V+emBOkh45oq31JBGe0HK+f5gqtfvOjRNPdSDmeEB?=
 =?us-ascii?Q?8wInl8VPV3c3jJTHErGChPxxe6HJAqBSXhk+MkkKLY3NjO+pOymUx0su/x0L?=
 =?us-ascii?Q?Tx2cteXUGySxHSCvfRbHHXZ+nSGjqDbInZB3xnDff0TCHu3aljiUJq6mOtsb?=
 =?us-ascii?Q?Q1wvlep8TKL82LaZeNzA9EM/GFGbpcHpRSHTBGWNZwiolnOaCY56tMHyyWvq?=
 =?us-ascii?Q?P5oVUrGXuu7leOWXqlAK36WBRnXlgjDemt2OfLTLAVk3HFWIx2biEhKH1Q6t?=
 =?us-ascii?Q?3e5hIyOxKfVqlEJfwEXSK2RlKJQrlOhgY92mwcMzKmSvJv8DGdn5EEJ4KHSX?=
 =?us-ascii?Q?MyWyI2Q4xjjOXBcFJu8mTJSxPhGrv7En+uxudgH46JTdNViESsvbqPyA5Dnw?=
 =?us-ascii?Q?aLZCD+PxxVq9JaWyls6q/Vb3KKoVzWu4ODDll1/1/sxcUH5DkF9eH8naQ2UD?=
 =?us-ascii?Q?Ti3o5lwI73FaiNmUnXy7VGOrcIIrSsjgsQEqhOTnuI/N2Dt4N2GoWRVu20iZ?=
 =?us-ascii?Q?DgafKtBzYmRa5MNbOABSWYuwEhx/jKuZjSFGcFeZifUEQK+1Kk+P09vKAGb8?=
 =?us-ascii?Q?YVQRPi341XlCSXt4pLwAmC0rv4BhifnFp0uU8llGdkqZB2pNyUXumrp6aTBE?=
 =?us-ascii?Q?nAVKS+yRpVMVcGACg0E0REfFBwWeH4XMn/djrgc+z6jjQxMpyxtiQS586hyT?=
 =?us-ascii?Q?cFU4mM/S9vroA5akbEEqR8B/9Kit7NI=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 621d769c-c76b-4007-cd49-08de41e0c3ec
X-MS-Exchange-CrossTenant-AuthSource: LV0PR02MB11133.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2025 05:04:34.9337
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1R+SaLxA2Ka/M7g2k+UvEHpdN9Ccc1Fl6hAXh8v/jYVivAOMj59YFkJ0D9/pT4F+b24kpbSM/BsNzjxNZ1/ry2h78/SaPebKlMvfMvGIWo4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR02MB8560
X-Proofpoint-ORIG-GUID: ubWB_F-hzhlB3cX8HBIinycvgPJNTQUG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIzMDA0MCBTYWx0ZWRfXzZFewL91ZSd+
 pyYQVU99ULnVEHV1SwMWYQv0ABV88+p1UbbyG5RzihkiDjWbbndvgZFIzsZ8KV+CN7EcbBHjGcE
 URNpt9568Rn7sC1Zppomu/+hcy36NafBoa1mVoMYgEyzLWP0uYxTNeP0aeMg1SfiF9TdKHZotAe
 AQ/g/SihtaQjqbsgF1lETJSLcEZ+uOckvqM6SzckmaIKpTVS21HTd0+DPwjgriphNd2ly/V52jt
 kmHJeBF2Ar4SunCpWBHQyQAXk3j8q4L25X5f1MbR0/xFqnRRPs/4jfwUlsctpUToOG4yhFWr890
 SWbKWrJd90OyN3o9qAABO8ep2ByfsDe30DszxVt9hJ0ama/hfbbcu0CBhV0HgHrNj7s3TR/uM3W
 21s5/dJLouyMghJIwwmqzTOQFjKNsPLQKzc150H8m4GmNPeYJsnCw3FwHgN/Zbx772txwcm2Vs1
 SgjnS2uCUW48psQ9RMQ==
X-Authority-Analysis: v=2.4 cv=S8TUAYsP c=1 sm=1 tr=0 ts=694a22e5 cx=c_pps
 a=zLxRk7/rSTrB1jskNZbxBg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=64Cc0HZtAAAA:8 a=mTso-R6HNDvPYhgs-xYA:9
X-Proofpoint-GUID: ubWB_F-hzhlB3cX8HBIinycvgPJNTQUG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-23_01,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Extend __vmx_handle_ept_violation to understand mmu_has_mbec and the
differences between user mode and kernel mode fetches.

Add synthetic PF bit PFERR_USER_FETCH_MASK in EPT violation handler,
used in error_code as a signal that the EPT violation is a user mode
instruction fetch into permission_fault.

Extend permissions_fault and route mmu_has_mbec to a special handler,
mbec_permission_fault, since permission_fault can no longer trivially
shift to figure out if there was a permission fault or not.

Signed-off-by: Jon Kohler <jon@nutanix.com>
---
 arch/x86/include/asm/kvm_host.h |  8 +++-
 arch/x86/kvm/mmu.h              |  7 +++-
 arch/x86/kvm/mmu/mmu.c          | 66 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/spte.h         | 14 ++++---
 arch/x86/kvm/vmx/common.h       | 22 ++++++-----
 5 files changed, 100 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 66afcff43ec5..99381c55fceb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -286,7 +286,13 @@ enum x86_intercept_stage;
  * when the guest was accessing private memory.
  */
 #define PFERR_PRIVATE_ACCESS   BIT_ULL(49)
-#define PFERR_SYNTHETIC_MASK   (PFERR_IMPLICIT_ACCESS | PFERR_PRIVATE_ACCESS)
+/*
+ * USER_FETCH_MASK is a KVM-defined flag used to indicate user fetches when
+ * translating EPT violations for Intel MBEC.
+ */
+#define PFERR_USER_FETCH_MASK  BIT_ULL(50)
+#define PFERR_SYNTHETIC_MASK   (PFERR_IMPLICIT_ACCESS | PFERR_PRIVATE_ACCESS | \
+				PFERR_USER_FETCH_MASK)
 
 /* apic attention bits */
 #define KVM_APIC_CHECK_VAPIC	0
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 558a15ff82e6..d7bf679183f7 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -95,6 +95,8 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 				u64 fault_address, char *insn, int insn_len);
 void __kvm_mmu_refresh_passthrough_bits(struct kvm_vcpu *vcpu,
 					struct kvm_mmu *mmu);
+bool mbec_permission_fault(struct kvm_vcpu *vcpu, unsigned int pte_access,
+			   unsigned int pfec);
 
 int kvm_mmu_load(struct kvm_vcpu *vcpu);
 void kvm_mmu_unload(struct kvm_vcpu *vcpu);
@@ -216,7 +218,10 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 
 	kvm_mmu_refresh_passthrough_bits(vcpu, mmu);
 
-	fault = (mmu->permissions[index] >> pte_access) & 1;
+	if (mmu_has_mbec(vcpu))
+		fault = mbec_permission_fault(vcpu, pte_access, pfec);
+	else
+		fault = (mmu->permissions[index] >> pte_access) & 1;
 
 	WARN_ON_ONCE(pfec & (PFERR_PK_MASK | PFERR_SS_MASK | PFERR_RSVD_MASK));
 	if (unlikely(mmu->pkru_mask)) {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b0eb8d4c5ef2..673f2cebc36c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5664,6 +5664,72 @@ void __kvm_mmu_refresh_passthrough_bits(struct kvm_vcpu *vcpu,
 	reset_guest_paging_metadata(vcpu, mmu);
 }
 
+/*
+ * Check permissions for MBEC-enabled EPT accesses.
+ * Handles all permission checks with MBEC awareness (UX/KX distinction).
+ *
+ * Returns true if access should fault, false otherwise.
+ */
+bool mbec_permission_fault(struct kvm_vcpu *vcpu, unsigned int pte_access,
+			   unsigned int pfec)
+{
+	bool has_ux = pte_access & ACC_USER_EXEC_MASK;
+	bool has_kx = pte_access & ACC_EXEC_MASK;
+	bool write_fault = false;
+	bool fetch_fault = false;
+	bool read_fault = false;
+
+	/*
+	 * Fault conditions:
+	 * - Write fault: pfec has WRITE_MASK set but pte_access lacks
+	 *   WRITE permission
+	 * - Fetch fault: pfec has FETCH_MASK set but pte_access lacks
+	 *   matching execute permission. For MBEC, checks both guest PTE
+	 *   U/S bits and CPL, both are additive:
+	 *   * If neither UX nor KX is set:
+	 *       always fault (no execute permission at all)
+	 *   * User fetch (guest PTE user OR CPL > 0):
+	 *       requires UX permission (has_ux)
+	 *   * Kernel fetch (guest PTE supervisor AND CPL = 0):
+	 *       requires KX permission (has_kx)
+	 * - Read fault: pfec has USER_MASK set (read access in EPT
+	 *   context) but pte_access lacks read permission
+	 *
+	 * Note: In EPT context, PFERR_USER_MASK indicates read access,
+	 * not user-mode access. This is different from regular paging
+	 * where PFERR_USER_MASK means user-mode (CPL=3).
+	 * ACC_USER_MASK in EPT context maps to VMX_EPT_READABLE_MASK
+	 * (bit 0), the readable permission.
+	 */
+
+	/* Check write permission independently */
+	if (pfec & PFERR_WRITE_MASK)
+		write_fault = !(pte_access & ACC_WRITE_MASK);
+
+	/* Check fetch permission independently */
+	if (pfec & PFERR_FETCH_MASK) {
+		/*
+		 * For MBEC, check execute permissions. A fetch faults if:
+		 * - User fetch (guest PTE user OR CPL > 0) lacks UX permission
+		 * - Kernel fetch (guest PTE supervisor AND CPL = 0) lacks KX permission
+		 */
+		bool is_user_fetch = (pfec & PFERR_USER_FETCH_MASK) ||
+				     (kvm_x86_call(get_cpl)(vcpu) > 0);
+
+		/*
+		 * A user-mode fetch requires user-execute permission (UX).
+		 * A kernel-mode fetch requires kernel-execute permission (KX).
+		 */
+		fetch_fault = is_user_fetch ? !has_ux : !has_kx;
+	}
+
+	/* Check read permission: PFERR_USER_MASK indicates read in EPT */
+	if (pfec & PFERR_USER_MASK)
+		read_fault = !(pte_access & ACC_USER_MASK);
+
+	return write_fault || fetch_fault || read_fault;
+}
+
 static inline int kvm_mmu_get_tdp_level(struct kvm_vcpu *vcpu)
 {
 	int maxpa;
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 74fb1fe60d89..cb94f039898d 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -383,14 +383,18 @@ static inline bool is_executable_pte_fault(u64 spte,
 	 */
 	if (WARN_ON_ONCE(!shadow_x_mask))
 		return fault->user || !(spte & shadow_user_mask);
-
 	/*
-	 * For TDP MMU, the fault->user bit indicates a read access,
-	 * not the guest's CPL. For execute faults, check both execute
-	 * permissions since we don't know the actual CPL.
+	 * For TDP MMU, fault->user indicates a read access, not CPL.
+	 * For execute faults, we don't know the CPL here, so we can't
+	 * definitively check permissions. Being optimistic and checking
+	 * for any execute permission can lead to infinite fault loops
+	 * if the wrong type of execute permission is present (e.g. UX
+	 * only for a kernel fetch). The safe approach is to be
+	 * pessimistic and return false, forcing the fault to the slow
+	 * path which can do a full permission check.
 	 */
 	if (fault->is_tdp)
-		return spte & (shadow_x_mask | shadow_ux_mask);
+		return false;
 
 	return spte & (fault->user ? shadow_ux_mask : shadow_x_mask);
 }
diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
index adf925500b9e..96bdca78696d 100644
--- a/arch/x86/kvm/vmx/common.h
+++ b/arch/x86/kvm/vmx/common.h
@@ -83,6 +83,7 @@ static inline bool vt_is_tdx_private_gpa(struct kvm *kvm, gpa_t gpa)
 static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
 					     unsigned long exit_qualification)
 {
+	unsigned long rwx_mask;
 	u64 error_code;
 
 	/* Is it a read fault? */
@@ -92,16 +93,17 @@ static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
 	error_code |= (exit_qualification & EPT_VIOLATION_ACC_WRITE)
 		      ? PFERR_WRITE_MASK : 0;
 	/* Is it a fetch fault? */
-	error_code |= (exit_qualification & EPT_VIOLATION_ACC_INSTR)
-		      ? PFERR_FETCH_MASK : 0;
-	/*
-	 * ept page table entry is present?
-	 * note: unconditionally clear USER_EXEC until mode-based
-	 * execute control is implemented
-	 */
-	error_code |= (exit_qualification &
-		       (EPT_VIOLATION_PROT_MASK & ~EPT_VIOLATION_PROT_USER_EXEC))
-		      ? PFERR_PRESENT_MASK : 0;
+	if (exit_qualification & EPT_VIOLATION_ACC_INSTR) {
+		error_code |= PFERR_FETCH_MASK;
+		if (mmu_has_mbec(vcpu) &&
+		    exit_qualification & EPT_VIOLATION_PROT_USER_EXEC)
+			error_code |= PFERR_USER_FETCH_MASK;
+	}
+	/* ept page table entry is present? */
+	rwx_mask = EPT_VIOLATION_PROT_MASK;
+	if (mmu_has_mbec(vcpu))
+		rwx_mask |= EPT_VIOLATION_PROT_USER_EXEC;
+	error_code |= (exit_qualification & rwx_mask) ? PFERR_PRESENT_MASK : 0;
 
 	if (exit_qualification & EPT_VIOLATION_GVA_IS_VALID)
 		error_code |= (exit_qualification & EPT_VIOLATION_GVA_TRANSLATED) ?
-- 
2.43.0


