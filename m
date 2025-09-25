Return-Path: <kvm+bounces-58787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 83180BA0C19
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 19:10:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5BADE3B270F
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 17:10:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E4E230C349;
	Thu, 25 Sep 2025 17:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nIEe/Foe"
X-Original-To: kvm@vger.kernel.org
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012013.outbound.protection.outlook.com [40.107.209.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB2D30B52D;
	Thu, 25 Sep 2025 17:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758820198; cv=fail; b=WugN4hxCikGV6oH1pTsEMDGH8Jj6S29ReUIUUnlikOT0MaBqIMvXzZ9ibz07pLAZuHRV+5qZt30qeRxZurNv3MOMBykXjih61fpxK+NRNVejidESxl/G9OTWl4TdMf+WH/0tFbLTgUxcwoFqK66Oh73DZNFof/lqn9x+ZWdfcS0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758820198; c=relaxed/simple;
	bh=JuXAYVsrGrfITpPjxN57ngDTHjkupRGfseYx+iVc/kI=;
	h=From:To:Subject:Date:Message-Id:Content-Type:MIME-Version; b=iZGl72udFTxnLn9iuYFpezhieMHnj1z0VoZSxCzcyWuW0Mx65eX1GzBfl9POAy7DE+J1YirJ/VMeyB4jO68uTJQedcdZEfx9tjI6pYx8+xSHh7RTyizTeF8HheSeMYZqtoNwIYndEHSP5U29k0acevAvL9f++SVoNbtijWzUNO0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nIEe/Foe; arc=fail smtp.client-ip=40.107.209.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L9UNFvf+ZFeO0GL33N4oB+XJqAjlZIGQ3BhF9TDbpMbWqN88+o17/hxKIuFRL3nZzxxhx6DUECJ3CoZiWPVEwkxHcHWnA71iYQpZQuoiXEptghu6tTBugDop+fOxf5jN7NDkDopLgY25/hdBwg5p9aVk+rbQlt5rCszlNtAeapz/qkBCHTVeYPd4J3yaj7CIm/p98etIUUyKhTMpygymmG5tPH+PhfWfQzDeF9ftS3nu3QoYHnLDzOA33vhYQLjr+E+tzyeW/lsZiwA0mesgReX7HVljEWleILE90hCt9Vrf3sI846iKWLDB6lvQQK2xfWdC9tGEvjIv90SWMzD+BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Wb5SNhug7ofXpvjn09I8f+06cKRHfIvDlwL1Fo7C/s=;
 b=og0bewvtSXrpsauLnKxMFoxrJGYfjLOLUCzhhT9Xa1wHx5/2MvyZQF2Vgvc1J+IoIEBiQiFrc0myZaS28EWZh6tyjsfKGNZckRu4FXnno80WMXqjJFCPzOdwA6LISbj6NBO1iRraVBz7D0JeWIhdpkMLEl/+j/MIVyNXNNY1vGMjmyB4vyUsE3/leaYQ7UIHhHJDSglGDYgyASZilawjgEYahD8ZYondznwSvVvLs9m+TyZxKkNXCR601Ci3Aeo7vkbK2dBtmxJw2deot7sRapk2vMH3BHDdx7zplsK7vQ+KzyXRjBWP7LGpJq4IRSZY7DaocdMX7eKbhMpMLp3Msw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Wb5SNhug7ofXpvjn09I8f+06cKRHfIvDlwL1Fo7C/s=;
 b=nIEe/FoeKZmJmmYUPnZM6M2bQv1zy7J2PtNj9BlGplcgwhlNa6Y6ooBF7hlamaEuKNoVteX6bI33AngGk4mUA0IoNdKHl3ZTckTjuWm2hLM6ywhpEXDS4FraWPENbMJTnVKBxjb4S8sSGN7BKS5ANX09/HkS+1Buko8muzK+5KWpb2H4Ttdez8Dx+kxMQA99+SHn0vOnHE9/lpm0QZo3jYk/v/KhPcyz+NAPVgsepOwIzDR1qPAw7GUEm7Fir2MfZ5a6wDd+5pXLttQ6DBhA7aS3KaHtNeGDFuIMYIdEvW97yYk9cvYpuVBFziakvVJshHK6Wdx21Q8MOR1Aj3fHew==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4186.namprd12.prod.outlook.com (2603:10b6:5:21b::11)
 by MN0PR12MB5835.namprd12.prod.outlook.com (2603:10b6:208:37a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.11; Thu, 25 Sep
 2025 17:09:53 +0000
Received: from DM6PR12MB4186.namprd12.prod.outlook.com
 ([fe80::af59:1fd0:6ccf:2086]) by DM6PR12MB4186.namprd12.prod.outlook.com
 ([fe80::af59:1fd0:6ccf:2086%5]) with mapi id 15.20.9137.018; Thu, 25 Sep 2025
 17:09:53 +0000
From: Tushar Dave <tdave@nvidia.com>
To: ankita@nvidia.com,
	jgg@ziepe.ca,
	yishaih@nvidia.com,
	skolothumtho@nvidia.com,
	kevin.tian@intel.com,
	alex.williamson@redhat.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] vfio/nvgrace-gpu: Add GB300 SKU to the devid table
Date: Thu, 25 Sep 2025 12:09:35 -0500
Message-Id: <20250925170935.121587-1-tdave@nvidia.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0057.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::32) To DM6PR12MB4186.namprd12.prod.outlook.com
 (2603:10b6:5:21b::11)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB4186:EE_|MN0PR12MB5835:EE_
X-MS-Office365-Filtering-Correlation-Id: de6f6f90-fbac-489d-9cc8-08ddfc565813
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IDUiG5BTl+BEQ9DgkJ1Sj97O75HHUNmbtYQJhke2sNT9qqVh58jNbWCfUmhw?=
 =?us-ascii?Q?HFif/IuERVxdn86iB1UeEpXsQbXc3WlHs6n1LWyfERAOOh7KS8o0FHIu879f?=
 =?us-ascii?Q?UyWKufo3Fah1yMzWUPrakM/N9vHGEwAvAayCwk1CLlk9RaNVjAcD5IJ/V9KP?=
 =?us-ascii?Q?SxOz3vtzZy092n0tX7HSPQKwEm3C3MKUfCE8n8mOcvp5eRo+gS2KtlTBKkdE?=
 =?us-ascii?Q?DFis2TUHRHLDHDX7AghUeKZE9XU5/ZXn1mymR7perUlMNHHTJ8rhcCSExOCL?=
 =?us-ascii?Q?hFcZFXEm49C0ueYtcCfyQXOZshFUqZisSdUG9xFvjcEj96jw6ZlEgFsbMxnl?=
 =?us-ascii?Q?rNBneQox3nlNkQbC89TejXGQ4mARBqyPBq7GYufWRv2gbNYScgS0Y1gpHVLj?=
 =?us-ascii?Q?aNUWCLwoqiNkmDvEiw5pxYoTnPWbHxHDeGyzWhKkZdMDJMcYq4UJnX/YbvBR?=
 =?us-ascii?Q?5R1QlSw4s4X1KlET2FY8NapaliVMg5hsSBvPqjL45Kbt3J+7RfqnReVElZtV?=
 =?us-ascii?Q?bttjI5ABmKwr3J6A2RU708F4B+creNuzSnl0Hp7SlCTyeLdLqckjHxOzMWEg?=
 =?us-ascii?Q?EkVJinNLAOFE8zA2+8+lN1dkAyuW9WbalPV0hczB322Fjq8kMPOl9Bs7wSuQ?=
 =?us-ascii?Q?P64VueAZxee+j3o8W9jUw+Poh8EteUnhMlE82DkW9fPffXvONUKdVhyClAqw?=
 =?us-ascii?Q?6IOI5GU3xRXfhonfbgkwIRJVkN2OYDifOuZzqMw0ycpibuAdxLgniRm0tsYS?=
 =?us-ascii?Q?oZK/WY37TCO0VOwxO3WY8gQ/NK0p3WnDRI21mr37MJDv6wRZVxYAet1hEp/2?=
 =?us-ascii?Q?+yUV6DBMlfkf0mhpZYt6t/qekvUHQot3RPSoD9q0nYu6cMJb0DSG+fcNA9eA?=
 =?us-ascii?Q?Jen/9v5uCdEZY1Xb+gAXet6QEx26i+Q/djbM8y5nqo36wNjet19v8j6r33sc?=
 =?us-ascii?Q?oS9sNn7t8p30Tg0M1V85eUwJpSK23ffn/O7zeM3WU4AjvyXKqSPuD1Rk+zFz?=
 =?us-ascii?Q?k+5M5Dxbwyh3Wd39bbv0IF+MdYYb3LKaMrcVF5LWmzT7Y0/hcKT9VELRW4fG?=
 =?us-ascii?Q?MNhRVCWAVMFHPGMNH6GC81HV76ala/r/+lDyxLT/od08wGWWCIih9HkdJ0M4?=
 =?us-ascii?Q?kTEysM92aDb6hAxIi0RDs0wRLxXB6oyw90cbah9rY48mL6/qCJtI971ABR54?=
 =?us-ascii?Q?KV/UKj5Kpn9ytW8cUzuQAsOAzKmUtBsqjBUtkQyP+krPFGvpu2OzeUGWXP9E?=
 =?us-ascii?Q?NPqVCCKRZIcA8S7ZcpylzVOjJRcanED2dYiKG/Q9Q0FUQhqgkQ7C3vRhvH43?=
 =?us-ascii?Q?L2PKp/i1OhOZGbuZNVU7yo3kLxEnkg115514phuBlZvFTzyf9q1uFn3+X3K2?=
 =?us-ascii?Q?PzauuMMS5TE+fY4EMdKrCgv3+VuXnX7hvpklcpD00zEmXC6OfJzcnK2T2FmZ?=
 =?us-ascii?Q?pbIwgf1qo5y692W+90j3xGC2mi3vYL92?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4186.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0pE1ksL6/1d4DaHQg6XUkLxDFRCIdajs0eAwv+3TLZfFYEGGSh8JxLvZncrm?=
 =?us-ascii?Q?UnXiRzcCkjn0V/fSrwOzhq1HI4v9qffU+Pi34fwinJGOucxicm8NB2lGsV17?=
 =?us-ascii?Q?wOlW+pLv1OmduRxxUOtyFnc3bQAubAvINZVcfNsSKlysmizLiiOR6gyly/ef?=
 =?us-ascii?Q?P7Q5gRZ90O75JKMwvZFDv9TGLhiDHFTwcTH0AeZszd/WSPJqx75cd8EwgmUd?=
 =?us-ascii?Q?/WiAb2bdtfHc810IT9bUGe8TtekFiLtQEGAdQKdC1z0YWIDo8dI9ZXPkpQqv?=
 =?us-ascii?Q?FdSHKmzKMqca+5+z3jMsZYNFpNMtPcim6Xy4ZNDWn8HVEOyEBVZyoA603U7K?=
 =?us-ascii?Q?ZdpVWuvZvMZ+NkrWuBmtR1Bv+ZrOUYUkIhlVTokf2ujyAn18E7tnTJTfoCv+?=
 =?us-ascii?Q?NClDtjUa2E6FimHtWPdGnquTeAx5GfS5P3Gh3pfFJZa7NIqAjXiUDmgfLBU9?=
 =?us-ascii?Q?2ewNL5ZHsj+CEng1MnkL8knkZb8mf36OyF4MmAMUE+7iSkSOj03Jy5f7VsSu?=
 =?us-ascii?Q?gSsj8z5xU7hYUcEMweWlyup4GYdyAy8JNc21Qf3aluNuyOtUHor9KIgYaCcx?=
 =?us-ascii?Q?0SmQoQrcUw+zjHJE2IJkx3GqTqslZh8Ijf6InP1IEq3Ug/5+7anb381o4H5k?=
 =?us-ascii?Q?VC96YyOOlFlJThEhkUkYw8Np5/WTUVftYBGWsLRr/kbLb2bSlUuW4NpsEFUr?=
 =?us-ascii?Q?LVESjFN/32S9GtLeoaZzCPdr+d+3I4YTos3HJRuwGQLbgAw+cPU5mhbGSO0v?=
 =?us-ascii?Q?ahKRvJ2hWVtIQ5gGzu+8x+5IQTSMceRmpntkuoQDbVgbn3NCM2ZENQXuUxmO?=
 =?us-ascii?Q?rgYrAadGI+fdzskFvzys82h26CmYUqHrLfA9i+Y9+ZubdLQ6o+iDEHpjIOzN?=
 =?us-ascii?Q?FAuATd0VzejDBrZHXuAIgFfQmmlQhfFBSRvrsKLl0tFu4S2d1HPpLVK+x7TJ?=
 =?us-ascii?Q?HU52j3sfYNqO3UVQAOeZ2Q4p+iz6agGqaNEjh07dNjw+vLl6pxcHJZV7/n8P?=
 =?us-ascii?Q?6BDx2YEoi4aXJM5LHOkgsdWg81g3aBdyb4T6DGc0XLJdOtVLAQx1Cjq8wlxn?=
 =?us-ascii?Q?SbJQritSoCoh40Sl3qna4jf9NaPPCeTg0I+Dtv4foAtiv5nuY0gfszmfWa3h?=
 =?us-ascii?Q?BsNeK3EwMEAWDsXiRlxjCTwCoRE9BNfLHJxDuI3YnPPr4Onft2BF2bm4DrHb?=
 =?us-ascii?Q?GXP7jdgxMDOekyjwNuqJcUHi9ROXtWGeGDzbDnNyAcc8WWn3HcJ6/lZSPaSn?=
 =?us-ascii?Q?qtAKfdenGXmyIb0prJp6mhcKrzKYAvUcQqPwblCIF6rg3F4lcVT3VLKYeJ8z?=
 =?us-ascii?Q?wnv4zKl5feAaxF9O7UiFoA/cIn0VxYEkNod/pQhV5dkThvXYm+Kfg8j7ayD9?=
 =?us-ascii?Q?62ZEobKcSMbQUAxT/QNm7agiV0vmK3fFQxdB6acqZIXQ016re6jxLbfliPOQ?=
 =?us-ascii?Q?ghVQhMz5XIsoC39LQWEUEtPuxKKzxMcgRCZlZ7Uw3nvUI6JGUuE2nwhqeSzD?=
 =?us-ascii?Q?N0cAvj1YMLZkY/br7vDXLYDsDuUCbox6rsjEMYmYzv1KooTfneodUv+kGtbk?=
 =?us-ascii?Q?zCu6JHPoFOE4mUsUVb909AvdvQ/xw2iipaOgqvQy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de6f6f90-fbac-489d-9cc8-08ddfc565813
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4186.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2025 17:09:53.2940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZG4fJnjtciVHnecLc1rzEZjHf4A7HPyc1RtEOr3NOG1hH2GdXzVOitrQvErKOqB8OKccDGL3/r36+Wme47IOkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5835

GB300 is NVIDIA's Grace Blackwell Ultra Superchip.

Add the GB300 SKU device-id to nvgrace_gpu_vfio_pci_table.

Signed-off-by: Tushar Dave <tdave@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index d95761dcdd58..36b79713fd5a 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -995,6 +995,8 @@ static const struct pci_device_id nvgrace_gpu_vfio_pci_table[] = {
 	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x2348) },
 	/* GB200 SKU */
 	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x2941) },
+	/* GB300 SKU */
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x31C2) },
 	{}
 };
 
-- 
2.34.1


