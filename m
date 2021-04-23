Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 430C3369D10
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 01:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232283AbhDWXEV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 19:04:21 -0400
Received: from mail-mw2nam10on2080.outbound.protection.outlook.com ([40.107.94.80]:21184
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229718AbhDWXEC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 19:04:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e0TGoPJLiPSYXeRO9JF5KccPscziu4DdpnrGdKA3aa74+dJsOnFaOI6DwgII2+Sx2SoDVZ2r8iUFHLSpaZRaa4a9nGED9FTgfXz9QNEwLR2dlAs5OmZNIOhKWQ4+F+KKtL2GVM7yx+fCB6as2WNdeom3IJhKTP8jDHrQjkeBNPJ9XLtjSi+7qg5dZL4omR6hLtRWtIfCuWDxJK8qQUhS7d4gzkb9dKA8JesQ/qY5dlqVWuwi/LZIIuLO2IYr9G0KbxonXwfKobNOeRsukQbBW7H8RbgiXlwPa8JZL+UjzdOFUytIL0zczZHWrS//P8nHGHIHx82bMHfDkqAGVTwtUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZMxUq/s34N0JU+0P06+FqCF0ddKtpv+/CFaEaJbNE+A=;
 b=BIRW5cpEeG7ujMVBZnIoiw0VI6ByKK22hojriBLLpL7QA2SCEjZwTom1rtvGhCpUti5YkSOBWc0070ZjUQK19tIiwPl2wXX0gZeG2Ag2up7WzCcvxzB/vj54M1PitoC2qlyCDf9DVVMKgyxGLBC9OaoV5vaSoloQip4eKAVsRauIijODvg/LyXTURRahpAT5RB+mfSSvKgZijnu1O/K/Hjp5ywZgkuvb+Q82ux6q4nYrXyVnhyzaSZV580yAhRBfe+aFTwJ0bOSJLja6Nv3x9JhUpNURpjrsYfLtdHNI7rrGPwXw08/aExDgwZH+ZS2jEII26nHdEYH0Nsw+cIeOrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZMxUq/s34N0JU+0P06+FqCF0ddKtpv+/CFaEaJbNE+A=;
 b=FOg5PC4mwIlrbBCrpIhqNDl5cOHKVNjPFpWlhOqJTkj8k6ScE/6DbZweQn0sIcK/QNDB4O6YlgbCDWla7RjsRCCkmouHxY8o7WG8oN8QKfZbGaHumsW0GFU9gezZo9PmV3hDn0aHQiP0bTxcXWqB4ZB9j8qn4evWqV8erzaAXAoKMjOPcsneg9lO3JROnGFrsnS+xI/R453+DtdXMPQIEGELlo5AJs0OplG6je1stRDTj66wb8FvLwcHluy9MM++ly1rSZ2Yla0734aTcGm7KWz5DKQUftaQcRK2up9203PA5s7G+rFVOgKSZ5DiAFgeBTHSVpyvaS0bq0dbx7j2nA==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3513.namprd12.prod.outlook.com (2603:10b6:5:18a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.24; Fri, 23 Apr
 2021 23:03:16 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.4065.023; Fri, 23 Apr 2021
 23:03:15 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH 12/12] vfio/mdev: Remove mdev drvdata
Date:   Fri, 23 Apr 2021 20:03:09 -0300
Message-Id: <12-v1-d88406ed308e+418-vfio3_jgg@nvidia.com>
In-Reply-To: <0-v1-d88406ed308e+418-vfio3_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR11CA0001.namprd11.prod.outlook.com
 (2603:10b6:208:23b::6) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR11CA0001.namprd11.prod.outlook.com (2603:10b6:208:23b::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Fri, 23 Apr 2021 23:03:13 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1la4pK-00CI0A-E8; Fri, 23 Apr 2021 20:03:10 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 503dadb0-a3f9-4d7f-cac0-08d906abf8b0
X-MS-TrafficTypeDiagnostic: DM6PR12MB3513:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB35134C5596600F76671438ECC2459@DM6PR12MB3513.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:741;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GRTWADswJ2nG4hFw8jZSkZFtN4rC4673Rip8yctl3nlNuo9kVfV8I0UVkSIgbl6V50gTCO7MgPwbBxm8dRIlMDPktlsVUP9V1PFsPq3C+cRyZXVDoTygAKF/SHWk8bITWTMm3SmySdfI7afNKKIPs3TYijxYyJ4L6RRwWBQftQmAwMCmHKgHg8bbNTd3oLVPXxpENBALXx1jeqM8LbirrNHosvv0/ERKbecJTy5Ggrpk+iFgVDWw/ETVXakh7fnAXXWuKVuKTj3IxqKG4RYQ1y9Jm+m8PqLHabt7cOISC/HGoj3d4U8eKy2fy86DQmAvMWzeTakOc5Jvo/Aw4+gljB+FvYiBSaNaUckb5LyglupNXaZjZDAsERUpfJyqwvUURgsTCPxa7zogDJlo9kbEJLXYm6e19v7Am0iO916QB9T40ru8FfTbLJXwiFD2uffVn4HgqTDIGUIAOvApW0Rgsqe1OR63u0TnbC+6toydOj4/CoUFbBGZi6PRskDW6hQJ5XCB3tFfAZa+sBCIbxg7uM0eMWQaYIWjoVgCXMRJY/MEqulrI0md4Ihjq4Ewbqek6pwFpEZqRzPjof3XoAawOSpRXUggimfvxQjdNuESBts=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(39860400002)(366004)(346002)(136003)(36756003)(66556008)(26005)(66476007)(107886003)(426003)(8936002)(83380400001)(9786002)(5660300002)(186003)(86362001)(9746002)(54906003)(38100700002)(2616005)(316002)(8676002)(6636002)(2906002)(4326008)(37006003)(4744005)(66946007)(6862004)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?HAyU4htSUgBWRpt69nGgMB2If/o/3862b/n6vfMoqVEyZKsK+QaQOS0XrnF+?=
 =?us-ascii?Q?LLXjxB5ImXYz+7/077Re+vLTztTPRZoDs9Y7jWDz5LVQuUBfxMXw9PoHbggv?=
 =?us-ascii?Q?QMbVZiYfMoEH61Ib+W4Cx+4kEMVLvNUdk8PaJZd/VLjap830dkVkWrdzDrtS?=
 =?us-ascii?Q?JCWZqhxlu6P7PpWh0tWKrltp1OWiQpLBZmKN2KlwD0Uv+4NHK0l7zGLrwk5Y?=
 =?us-ascii?Q?KEgLoV9bmhSGVA5srbyz//KrdD+g493xl9WNda3TQwSmHVLyT3SDSU+udT9I?=
 =?us-ascii?Q?ju+lV2d2oczkr4kuHU4DQjogwUtG691nr34LS5/tEAo+ghhYYdixtnp6YjWg?=
 =?us-ascii?Q?kZX1vAlRpyrva40bwzWdG9yakwt1gaUYVThJ/DNA/ADRl8Yu0swswXW1M//k?=
 =?us-ascii?Q?tXKkJdmaiJA7u/Qoa5V8S5Vv0VXf8SqZSML0vAFdIOxJ5X3Efsp0hS6edinW?=
 =?us-ascii?Q?jassFoyeaIA5vDVcy76TfqFtf2H0mRya8BQxS6bPvbjW8gU601JfiY/IK3FK?=
 =?us-ascii?Q?WLENiVCjfj9F3HyFEmmIPRN5fV9TleCVaKxtIet2yh0aI8O5NhWTK5gdSc1Z?=
 =?us-ascii?Q?M9otlu5+ffHFbVOfa0qowr9fXCNjNTObbuHtemYWSGU0NzV42TrVkyxVyOBl?=
 =?us-ascii?Q?9bCe1hu+2cHkKKsPrIAjDiKxwlBSWj4uvlsz64xYefD3Te4xM2iNunx8WM6B?=
 =?us-ascii?Q?pQkJZs3H2jL97prLKNjNDvuPGYu+MbUoPYrLeu9H1eWekKQYa4oS5CmnF4jg?=
 =?us-ascii?Q?8jdVDSuFlBFTFhjRKWHCZlSlp6cVdqAX1KP2oF+yQ/jAY8acLtFWQHQmPwSx?=
 =?us-ascii?Q?N/5wy4tNnAPPeTDmsxkVf2lCQL+Up3Qry9c5bPepF9VkdpeWT5rgx0zmBw5l?=
 =?us-ascii?Q?pPkMe6wLQ4CW/qHw0QFrxZIeJbPlTMkL2MYNN1f6BAh9UgOXd+YOH/34JO7A?=
 =?us-ascii?Q?VPedoO2wun+tpwKFOBkroVHfhJ9AvMLC+8hKH5EXyztIRcRI0m8FBh99BaH0?=
 =?us-ascii?Q?vDFUgN6BecoLMMoVlsI9UUiwHzHDGQLIdtIUfrCdbrzhpl2GipZ1L0FAf6T5?=
 =?us-ascii?Q?bonS/TWQ00GdNcXMxhh8y7iLqaGeLm5WUKdbNsvyUeQIJkG8qkecgiGU3XzK?=
 =?us-ascii?Q?laEmVE/IEuy+1CW4l64dIWCrc90JX0wniIOxMRa/PuTMIIS5W3qU5iSoYRwf?=
 =?us-ascii?Q?PJlA6yLAaLCdEx9GJhVLHzChKfnu5N5Q7D9NEbGZuyXTafc9fLA5fdeaukBT?=
 =?us-ascii?Q?ARDCDNzyt/reQzGAnMEFlmxEwB++WRBezwvNUW7GyDy8dIrVyewRZ+rZbeVu?=
 =?us-ascii?Q?LW5zyWDjrDWVR6OkCo8VhL+N?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 503dadb0-a3f9-4d7f-cac0-08d906abf8b0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 23:03:13.4304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m0NeZ83qi/QDDAvXPMM1/k1F4dyB9J/9Fu/5CKKcxA6sMM5KI4HNlwOgP4a6Jg1Z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3513
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is no longer used, remove it.

All usages were moved over to either use container_of() from a vfio_device
or to use dev_drvdata() directly on the mdev.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 include/linux/mdev.h | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/include/linux/mdev.h b/include/linux/mdev.h
index af807c77c1e0f5..2c7267f1356d78 100644
--- a/include/linux/mdev.h
+++ b/include/linux/mdev.h
@@ -15,7 +15,6 @@ struct mdev_type;
 struct mdev_device {
 	struct device dev;
 	guid_t uuid;
-	void *driver_data;
 	struct list_head next;
 	struct mdev_type *type;
 	struct device *iommu_device;
@@ -87,14 +86,6 @@ struct mdev_driver {
 	struct device_driver driver;
 };
 
-static inline void *mdev_get_drvdata(struct mdev_device *mdev)
-{
-	return mdev->driver_data;
-}
-static inline void mdev_set_drvdata(struct mdev_device *mdev, void *data)
-{
-	mdev->driver_data = data;
-}
 static inline const guid_t *mdev_uuid(struct mdev_device *mdev)
 {
 	return &mdev->uuid;
-- 
2.31.1

