Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 362F5397928
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 19:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234017AbhFARfJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 13:35:09 -0400
Received: from mail-dm6nam08on2077.outbound.protection.outlook.com ([40.107.102.77]:23618
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231726AbhFARfI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Jun 2021 13:35:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AMeMzROTeSe3q5iwpL8B/KpGuSFpUeu8lKimk3C8vmj+m8x46CVYj8Hh2t+b6GIhzR6lpTI3lT5wxh2zfUTImeHcMivK3hqM7bBYdjLPtSECsgmcOUXz5gu92ecRsVtZoJ/lMjb16WLcAwQGcFv1MZY5G9g/8wBCWUKnh1OwhofSyBiFN7UiGDXC/rU0PmrhupfiNGogOAklSunECtKJvtWFt5pUY0Y3OONkfg4ccmKjg02lDRCom0mh4nu9kcmN4WXnInyxV9Y7hjiX4hgW34So4sc9kb8WouzKgbnucI9Ne5riz5DBI47T+BwS56ctBxaXQIChPB2nfKeldMBeoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=972aMIjCCvKVx/QzGqnzcAYYQ12OEzV5Fwh18D8EtN4=;
 b=OpgeMgdLHbimw+5BqJt2kfbE0/k5Jv+aYqQoCl0xUeLvDT/5FtCKJrOcHbU7RJlyQ4gVJpDzxoDJOJtSEx+RNX9xeiDjp55neicqtnkH/HAg+WTSieuPPsLgccDQyHfGnPxr65+7HfUcAXnwcmDutcjgcWNLfqqs34o6pqV3e9bLr2BcnVlyC/uMja4FAJalZDk459tHmj39gKtjff/fnpOtIUQcIGVaoIGJqLM87fVEOB2UmIriZTL1A7ZsaRF8XoDXseqpSzMTG9jfH0zDXoB7OzJHo4RQt1xlsFtzoodTWtggKWB8WyObsRNi8NqjBOvD2Zs2qC5weSYiyCr4Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=972aMIjCCvKVx/QzGqnzcAYYQ12OEzV5Fwh18D8EtN4=;
 b=gHasC0jPMvehWUz6rNF9+jWDuHGayIuMn7ZnSiVfnICAreA2/QYtGxQ7I9MTS6zZBeGd71/mGY05BYfzJylPds69bXrBWRe7TXUMJXng/opRDWLElVqacxliiC5mc6YHcoAFbW7IVIQqDuRR2gWw+hKMcPwlU1zlo1/UtdA+WLEHgbIIwrM1mUWTdgnWLTLTH1anhYcX/7p0OPK3PyLmkIRtxms0t3gidBS+jeGNU3sAis1rfsd++eg0TZVrIF7Fun0Mo6blQtU/jYWQQXJri+KAcoalNMJuksmToXvCqkbY0W2kPBz+z034vuzL4ZF4lWTf1BFoCNRMOEZ3o4zevg==
Authentication-Results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5160.namprd12.prod.outlook.com (2603:10b6:208:311::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Tue, 1 Jun
 2021 17:33:24 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4173.030; Tue, 1 Jun 2021
 17:33:24 +0000
Date:   Tue, 1 Jun 2021 14:33:23 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Shenming Lu <lushenming@huawei.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        "wanghaibin.wang@huawei.com" <wanghaibin.wang@huawei.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210601173323.GN1002214@nvidia.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <c9c066ae-2a25-0799-51a7-0ca47fff41a1@huawei.com>
 <aa1624bf-e472-2b66-1d20-54ca23c19fd2@linux.intel.com>
 <ed4f6e57-4847-3ed2-75de-cea80b2fbdb8@huawei.com>
 <01fe5034-42c8-6923-32f1-e287cc36bccc@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01fe5034-42c8-6923-32f1-e287cc36bccc@linux.intel.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BLAPR03CA0125.namprd03.prod.outlook.com
 (2603:10b6:208:32e::10) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BLAPR03CA0125.namprd03.prod.outlook.com (2603:10b6:208:32e::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Tue, 1 Jun 2021 17:33:24 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lo8GZ-00HXfZ-LK; Tue, 01 Jun 2021 14:33:23 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b8939ce-632d-4ca0-2c80-08d925235be6
X-MS-TrafficTypeDiagnostic: BL1PR12MB5160:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB51608EB893ED4C8EAEAE7323C23E9@BL1PR12MB5160.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hd4hewq6jcz0vJ8uS6Aq14p3r2rTod4C6fJ/C73I+KT6z/nw8b0DvoeoTvGYIfIFsdmOB92CQR3tp6xBqEepooHtzYoIUKXVnj5+8xob0mDad8yJxX93OQjZt0+QM6Wr98wFRfR7p5zzcaHUFw0Z60HdC4TyWRQ9dX940H2jiLJcfZ5IowiZwiVIH4zRyGew7pYD+exKmXuPK6WBGKrEM2+Vc+nJKHadnWBnWfoGWJ3SqUQjjWEO/Yb+tDCdXiqX0uwuKfRd9RLfcas9FXXuPTth6YGYoxASYhE1/dDKEgcUHtT0k5upjhufdB9ynmEMUv3MhHyLIL7cF38bsfFlGt1nBJR5ws49ZUDgzsuA5rHKYJhkzlWgLyq5MITEs/KuljEUNIbLYLg4DE3FKF4REu9aoyg+SmO/GQX9o84gOPB1IoIabetAuWstw36QkJ7NrRJsutAfPC87BAXMQoPZyba5y5ke6hO2Hv11TGSzHyeeCsmS36FzJ9z2TTwPW4DRqONkpNKhSyoVAisUYEXsNO6Y4kq11rmer2+Ykz2EikUgvLww/2FvBkNC009uRjO10KrtTHh7HpUpLpIPb7K0TnzLrc1E1DKBjUuAjOug4lM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(376002)(366004)(396003)(86362001)(2906002)(8936002)(9786002)(6916009)(33656002)(38100700002)(316002)(478600001)(54906003)(4326008)(8676002)(5660300002)(9746002)(1076003)(36756003)(66556008)(7416002)(66946007)(66476007)(26005)(426003)(2616005)(558084003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?gV3KhkMj57eGFoGPTUH2kjxzWCNGChc8BtzHAnGuSAOTSCO/3Hj4VrOZisW/?=
 =?us-ascii?Q?p2HoVXBvdgGXZPDeA3/3dmZHfrBz6a4OBWeo80wEx8b56+yrDyIAcQ8t5rPf?=
 =?us-ascii?Q?UoBQ3w2je5yhD+4e1TM9+sBvso2W8MqFsPgZaY1sDFHMMqDCykO4djwc65gz?=
 =?us-ascii?Q?1rUswJI5oa31/1dmIKeKWuJwJkDMvBozQm47Qy/Ds0r9kGGgLiTFEmMukgnz?=
 =?us-ascii?Q?JwxDcZ8yovjt+G0vbdR5iMLSvD8kEE0f/qcmkeNj3elFpl46tqiKHB9VGyve?=
 =?us-ascii?Q?1PG5TH5H/1aDtv0Aibis1P+GbF2fdIwg8f5+kpZFWm1nNMXyJRV4bZJDhz7U?=
 =?us-ascii?Q?Tw8kLaL4u2WCpIblqMtKMqIzy7spxM96JPEz6c4E5VO8LbeauyS7m1qce2PJ?=
 =?us-ascii?Q?P2gjlEKU3ZT7ApqwZ5G3+SfETXEWrk7ytj6142OLL7jIIxBflvGkrnWvXTff?=
 =?us-ascii?Q?k4olucO6DIK/MaF6yL26umh/7+JHYLJ9XYoRDeJxY3g4iiyBun224P63is3a?=
 =?us-ascii?Q?fFIs2l880c6lt5mymH/fnfzEVKVGdqXEDB5Xnl6GdEM+fKtAcaEQTRgvd8/m?=
 =?us-ascii?Q?zU0JypsfanA39y7v8MfWYMUQwsww4ff6aqLUbHe3sPHNYvnq3R9x2WahGuVb?=
 =?us-ascii?Q?h+DPGnFmNFTPfwVvDHWPPi9MIPu4uGSjLpSr2pGpumc6i2T5XK2fdtKl1IDj?=
 =?us-ascii?Q?+OWflw+DwN3gQzgGXBW0RPtZ9qAzB2wrYTTUkkzszKRtRXRimOLfsswmAH4Z?=
 =?us-ascii?Q?6s30q7S5/VxJpFRaPJLkrY4z9kVEc17SgufN9AeNC0a09812hj7+PktOss3d?=
 =?us-ascii?Q?TICEHM923eT44+qbwm7cZrm25aHi37DkXCqYGlbV0oVWafFcSlSzHM5XAUgu?=
 =?us-ascii?Q?7/8ayZL5LMpdj14JYdf5DdYZ4pgQ4NGY4nF+oDTPcrfBTF8U8//2VdvlcC99?=
 =?us-ascii?Q?Ay2xCorJWJFToY0s2gix0um0OJZHDkIxPPIx/dL6tuPhKHHPYuUnvRXIj72h?=
 =?us-ascii?Q?txp9N0+JtOuXELexQDCZ5MUh3uNczJQ2avokLi/cSU4uNHvUtkbqO68GPT2V?=
 =?us-ascii?Q?wKLLowUmnHIRzYyzW4wsXm77SlTl79trFkVPm+VmiJjSafACxSxB/CteUajg?=
 =?us-ascii?Q?AxdWo6XhLT71HVyLIXtwQ+klHaKM6PZeyK8lFHlj8Li6GYCeX+KQw48EKyWj?=
 =?us-ascii?Q?hGcsP+UsrjroiBJvbkvLvgetznTOUFhPptTcRs1/p9STpYDT21H48gOdT5ce?=
 =?us-ascii?Q?XiAkVWRr3QQtPkoQOhnKPexT7mR2kOmmz8Wfd5jZjZi7JUxzXB5YwiZc5nsr?=
 =?us-ascii?Q?szLBzOGaF8PMop6wPeTCKat1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b8939ce-632d-4ca0-2c80-08d925235be6
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2021 17:33:24.7760
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jXdN7yTQj8d5ACU6oZ1BMUkH9bd9yfroZTAaojq9sps5zkjP1mou3RsSXPzpa6Mi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5160
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 01, 2021 at 08:30:35PM +0800, Lu Baolu wrote:

> The drivers register per page table fault handlers to /dev/ioasid which
> will then register itself to iommu core to listen and route the per-
> device I/O page faults. 

I'm still confused why drivers need fault handlers at all?

Jason
