Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8857F3466F0
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 18:56:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbhCWR4L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 13:56:11 -0400
Received: from mail-eopbgr690085.outbound.protection.outlook.com ([40.107.69.85]:23427
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231214AbhCWRzk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 13:55:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=flUvhaSqRseJUhqfP1NHX7/daGcFwTVSVMdmbm/Fb0H3hrBm2LSpUNPYZXPEfqu64sezdFqT0Ina0fCgovF1jTV/RELE9CQc32jFK7XL9ubQtByyxIaXb2titQ6iuVNTY0YgfyOhW1JZ7A24Ehdb6il2dnSWnKlMfD5VCxWN77Lx5KHl4Z/5rFwBg4daPpjXfRqptNIZUUItpEpoJoyzVZFVhreZsP3q1VJ10GofXXf5U1yJDP8MoleebY05zjRhjk1TGX1ZhTjHih75iESmDf/PL8GC/uzXyFAfnw3s8rjLTTtirQVJtpGtddX+qoSMcR0CpUv0oaXPcts1oF8xbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ETm9Coh7g03O/Saim5zxYpivmGUONCqTvBnD+Qp7bJU=;
 b=A9thg2Uom0Nc/Wdl0VvOvfkKykbilw4xrdDrBcFFJAgTXyCTfNH+iv6znxTgAOZipJ8L2Hv1qX43TmfJ17G82CdpCZPOGlDO3X7yrOn4zH9C8Ky2GseMsLSOHHAPLlVqNg7yZjs5Q7/PsOGi7vIGR1kdO/C3jQCz2SsP5UxI81wT0kRGpJ8r6iMDp6kwNTkic4nwOMmdoAynvA1hBIVkBciUbwHPRix+DE5PB1lZ67YOeMcKbPJb73RT9IFaI/s6UbrLDAk9MFasOQKp9QqQAdi9wGZUY8w8TOX0cQw4hel6YnPv+ftbLZc3Xw2iPeDBPI6vj4E+DCjpvUmsJWjsGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ETm9Coh7g03O/Saim5zxYpivmGUONCqTvBnD+Qp7bJU=;
 b=AeHJLSki61bVyhkQ4MLB/0wU8Qaw2wBLT4J2vF4EpNRwpYOqGjKQVTi75x0gSfKlR4MJoSSowZUXcBa8KeVT6AGTlXyIFKthVV/12tiif/7RwoEkJl77tnXo08zmNotTGVlJS9XOI6L894+51kH6NwrQMvck31+9vKhCSrjX2+2qxYSQ7/lMPq4GDEml3uKop2gCqQx0O8BURN3HlIdupOUt5YPcTVXEqeVCDcyx8nwtrqv32MEwzyD54VJOkO7mXM+7iUrpLN/z4fz0J5OzyTd9jbUTRBjzxCu6fR+0RTVUkqzVHOOrpDeFNrKvoXXLAtkhLSYpp9QgJSt/XV6fTA==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3932.namprd12.prod.outlook.com (2603:10b6:5:1c1::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.23; Tue, 23 Mar
 2021 17:55:39 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3955.027; Tue, 23 Mar 2021
 17:55:39 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dong Jia Shi <bjsdjshi@linux.vnet.ibm.com>,
        Neo Jia <cjia@nvidia.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Jike Song <jike.song@intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH 09/18] vfio/mdev: Add missing error handling to dev_set_name()
Date:   Tue, 23 Mar 2021 14:55:26 -0300
Message-Id: <9-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
In-Reply-To: <0-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: MN2PR18CA0009.namprd18.prod.outlook.com
 (2603:10b6:208:23c::14) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by MN2PR18CA0009.namprd18.prod.outlook.com (2603:10b6:208:23c::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Tue, 23 Mar 2021 17:55:37 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lOlFf-001cgx-Hl; Tue, 23 Mar 2021 14:55:35 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fcb63f99-ff48-4ed4-de21-08d8ee24dd66
X-MS-TrafficTypeDiagnostic: DM6PR12MB3932:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3932A884B750B2B2C284E747C2649@DM6PR12MB3932.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cekHjntakZv9GOAl4+2DsPN08VZBeWX37c2v5K9ztzr2HSMNG/4XSKh0DWEZ9nH7jtOkAOH/12CjxnYHw5fTLPB7fHlLTJb6g6lHeLkezIUQCk7fkQrNLTtGZ6mHTkeY/wlTTPX1WMa4MdXzCZDYNUYWjBmQy3vM2xwmRzoEwUAnorcLFB1TbJBSRi75a3Yh4Aj++rCWJ+ERJjJ8MCAoeB7M8W+JuGmfxQ6nr3sMdMiPjmtTesPH0F7BDB91Db0UFFSNmovIAQ7OF59hbHKzk7I7Gs5g8L7l4+8f8DO+st/U5+LGtmBhf4AbS7OVoX5TfjOV5Ats6XxO6Mq71CSheutyO1n89hiIjLpg+EXuJKjt0XAPmaIW7G1oU+Dy2EB/bvfIfNHMFxxkxQEDLihKAVrr4KJWGtrDPZOGgNcWS30FOxHADTxoN2ENXlEpOQbMQJi7WLHKI75zpViig+QESi7bLDflNc79DutU7Y33hQBro7awNNCd7flWYyCxz6qbVCm4y4zgt548qE9fluPU6lYhcBWaCi/KDRgYRnZxsTCzSZ4eppEx8S9ABQQkva3tZ1LDFwl6nF9Os1FBWYG8QNhXahWZdeQRaNmKeWUo8j+1egAy/umZM/O1dTLMnn/91ImZOZhDgTvR60Vpzh6IE12551wV0e6jbwCjDEBWJaB5c1TL3O95x9e0O9LDghBj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(366004)(39840400004)(396003)(346002)(2616005)(6666004)(9786002)(478600001)(66556008)(86362001)(8936002)(107886003)(66946007)(83380400001)(9746002)(66476007)(26005)(5660300002)(54906003)(4744005)(8676002)(316002)(2906002)(4326008)(186003)(38100700001)(426003)(36756003)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?tVgdF3qF66mntBoVNhr1QHmJAj42OA2m5BSW+0iFAUjUN/mvNRqiRDdejjFk?=
 =?us-ascii?Q?LKz/ilpg/cGopmAceGjElII1WcxXD2Souytrx2Y9tU+bdJBY5exLWRSPYqvy?=
 =?us-ascii?Q?P5m6ftS26BE6UZQc1/28LGQegSfVdnZ+E3UQS9vgP1WUZXoeei3oQhLFbHP9?=
 =?us-ascii?Q?GlciECSDntzd1M4GHtKcRh1Jt3rk9X58lsgWga+AO/Q1fFPDWdWZvXt0unVQ?=
 =?us-ascii?Q?t6tEg8uZJZyDYX2x2CQkAa50l7cW4q2xPmV2SWe8ig2TjA6iqLCtNz7eCfqc?=
 =?us-ascii?Q?V/O/I6cAmeGc1z7ALDJwxD8Rtxbs8bkVRxgr5To0LqzUF7E+wTx572Ebe4H5?=
 =?us-ascii?Q?YonQRUsnWHuYlFI4oDB+o3C+bQRIXdZTeavAwhSmNzFqLNYpYdaNWKzWYfAq?=
 =?us-ascii?Q?UZygmUmmqK/hPiLAxo48KRiHboNfaje4GDLZofdD1wBZ/C0inY8Nwhccyc1T?=
 =?us-ascii?Q?YVxOvfxFbpL3hFArM1yVo6SENbR5B8myuv8JqGXz00svRTkjznI2NOIm8dma?=
 =?us-ascii?Q?Ea1XJl+x1AgXDMrdgSCvcXo+gI6armhDeTgful2Fnl1C1IBoYoRcy4eDdk4W?=
 =?us-ascii?Q?ZZZyNIcYVZWLbdEzWD7FdMw71j01oodi3y8uVFnjWZZZMqysRCgpFfAGBPpC?=
 =?us-ascii?Q?YpFFiHUmBSiZVpc9QosNDRXUam8uibN1AB3+BjxBZa2gEju8n5LwUnfBJvP0?=
 =?us-ascii?Q?QztcA/F8aI+TldR5coGUPM2ypE77Nsz3QJ0RV5NthIde8SoVXlmmkuWAk0Uc?=
 =?us-ascii?Q?nhUzs4Jn6LJSVWbQd+28q42i6Y8vIV/twwIHHEeC6ka0d5qmAQMSm7iPfHEj?=
 =?us-ascii?Q?xVGMQquxhFLFRr/61+DG4aGzJb5C+PLz9yEXON6WzWt/VK/7Kq6qCRFZGBRa?=
 =?us-ascii?Q?uBf27d0jtyuYdBctdDbTEt6JGS32H5HalZHh5POvvYRcBAMPnNKVV+jgAOKq?=
 =?us-ascii?Q?FtDdw0PECAbfQ3B0O+qVEz6ffnsKGsTmmAX0j7bsEEn+/D2Ciu3x6S8gqqGM?=
 =?us-ascii?Q?crwRqGFR2gIKBRKC6Ug129lepONqC3wjtd6ZkT4her2QNWOdf+2U6/9cPrvR?=
 =?us-ascii?Q?T88Jxk2LJdj69UQmQMN3mh1biD25j+rACb2ss1leAJS042PrMfRRNmEpiLKq?=
 =?us-ascii?Q?h8eMMz8eQGDNdoDSu2xWGc8b1RgNsj73NLZpwg2/2aov9WXR66I2DmzoW/RN?=
 =?us-ascii?Q?QhgkVwAizKWcmaQnc33qLcIMvNnNhPAwQPWzS2PHw+PpmypcO8F4CmHgIlxJ?=
 =?us-ascii?Q?3tIUBdMTh/sds550HLdeetwJVc+3Rp6ixNmeBT5IPLmcHYEn1A3rsQCK+tZ8?=
 =?us-ascii?Q?3jePYCm//xa8Xqyqh68L46zd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcb63f99-ff48-4ed4-de21-08d8ee24dd66
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2021 17:55:37.6043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E9wKwToahgWmh7RhJ+N58WRXuzH2/yaNE2q2GNvAkgRc89L0xca9N/cUaGY4N8f4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3932
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This can fail, and seems to be a popular target for syzkaller error
injection. Check the error return and unwind with put_device().

Fixes: 7b96953bc640 ("vfio: Mediated device Core driver")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/mdev/mdev_core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index 517b6fd351b63a..4b5e372ed58f26 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -258,7 +258,9 @@ int mdev_device_create(struct mdev_type *type, const guid_t *uuid)
 	list_add(&mdev->next, &mdev_list);
 	mutex_unlock(&mdev_list_lock);
 
-	dev_set_name(&mdev->dev, "%pUl", uuid);
+	ret = dev_set_name(&mdev->dev, "%pUl", uuid);
+	if (ret)
+		goto mdev_fail;
 
 	/* Check if parent unregistration has started */
 	if (!down_read_trylock(&parent->unreg_sem)) {
-- 
2.31.0

