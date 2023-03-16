Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFA5B6BC64C
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 07:49:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbjCPGt2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 02:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjCPGt1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 02:49:27 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2059.outbound.protection.outlook.com [40.107.94.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB024AFFB;
        Wed, 15 Mar 2023 23:49:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JXvm/L7lGK0OokZtYPquQxBc78hA5jn9UZ5VHsfm2g2jg/4ldVaePdZ6PvUsBq9HchttUe4kxAz+ukIw73n4adiiQhdJ/+0dI6zl1+7jGUWiWTNjAQionei/6RIN8B+yXatV+N+CAknRjgyd63LMSlfO8qwzFELgWMi5v3/kFPyBrHvDnnYfxdPYi6/vpixpFrsFKni15CBrmkwmbEkkpEm0boVFEU47syr/ws8U7FJfk7nxfPjlX1UPhu381sw/Ypn53XaJ+iECUbLMJ1096228y4oJcp0ks5DRzylwnu5WA5uC8rulGadhhorW3kBI714lzftOpjs7aCTA+JLDzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fz5O4jEG7miSJcxzkj8uUIO79xI/yJIaoeVKRAB4Ym0=;
 b=GZRBbmnbBNa58IP2VJHQZKv034j2LFEQp7z6ayMXaG1kDHQAnWpfT/sCzgvT4N5E3GYlyO1XVVt3YlrpS7I3Ska238fLZjtGzyGgLJ5+4YZUoxSFv9roESInMzDe9wJNHUAYB1xz0Jz5iO2oMcdOxMH/SFyn/XTqqLD1SxSY9bf2JzZK8HNg/TS+LycGA8+PXl75mbFzl4d0+PW+ngHxfg9dLYvm6wuLS1hZtd0scdH61+j8ynLOXhd2e5E5mTe4SbLdXgzpgX86YTNuIN6HHJ4+1LWHEzKdR0leXOKPQUFbpx7nmXQrKIi0hXEF71sU5QIwfBiXxouvKn6pIB0+sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fz5O4jEG7miSJcxzkj8uUIO79xI/yJIaoeVKRAB4Ym0=;
 b=SRYyZtbdvPq0aOWRWTICfMzEMaljzUr0N3YL+3LujTZRUHS65CQR3oxUAoCGPGRrf/qkIXynmR42DfqzoCfutrBpGJxQn5ZcXSKdeqZx1iWrcUZ2sjqBxGL1ucSgioh4FSGa82xuEd9eCcxE6qS3BY9qHv4slTmsC9x9z4dgZ0vbZxxklvu9rE1cl4LH9ci6AlYg6DEo7kIa2SK0MGBEPjWxeE2RAMJItGJNhc7hxMHh5Ju2+X+Ur3CIdszG7+7ERKaBsnKBdYgFNs0XGuYqGXuRFTiX1feF0q02dw77p5Xke3NlDuPJgOI0ZHD1sF+RD+PdzLFK2IWWO2PAMaFMIw==
Received: from DS7PR03CA0074.namprd03.prod.outlook.com (2603:10b6:5:3bb::19)
 by MW6PR12MB7087.namprd12.prod.outlook.com (2603:10b6:303:238::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Thu, 16 Mar
 2023 06:49:22 +0000
Received: from DS1PEPF0000B07A.namprd05.prod.outlook.com
 (2603:10b6:5:3bb:cafe::25) by DS7PR03CA0074.outlook.office365.com
 (2603:10b6:5:3bb::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29 via Frontend
 Transport; Thu, 16 Mar 2023 06:49:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0000B07A.mail.protection.outlook.com (10.167.17.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.30 via Frontend Transport; Thu, 16 Mar 2023 06:49:21 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 15 Mar 2023
 23:49:10 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Wed, 15 Mar
 2023 23:49:10 -0700
Received: from Asurada-Nvidia (10.127.8.9) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5 via Frontend
 Transport; Wed, 15 Mar 2023 23:49:08 -0700
Date:   Wed, 15 Mar 2023 23:49:07 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: Re: [PATCH v6 12/24] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Message-ID: <ZBK74xltWbaWlftV@Asurada-Nvidia>
References: <20230308132903.465159-1-yi.l.liu@intel.com>
 <20230308132903.465159-13-yi.l.liu@intel.com>
 <20230315165311.01f32bfe.alex.williamson@redhat.com>
 <BN9PR11MB5276300FCAAF8BF7B4E03BA48CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB7529C7D0409B47430D7412C5C3BC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB5276ABE919C04E06A0326E8E8CBC9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB75293503F92A24A716DDE2C6C3BC9@DS0PR11MB7529.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <DS0PR11MB75293503F92A24A716DDE2C6C3BC9@DS0PR11MB7529.namprd11.prod.outlook.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000B07A:EE_|MW6PR12MB7087:EE_
X-MS-Office365-Filtering-Correlation-Id: c1877923-4379-4593-d076-08db25ea92ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kip1berpvovm4m31NfAbnSTPEorPBPbsvUls0Z+mO1aNZ1NAcvYYI51kg6+yom+18oEgw9/dAPA6JuuL38M0mrncJaxoXBy+mvkiKLfJIAWPHcs60mdoaovoSUFCZqIGG/Xc1wPmYKXZzsXjpXDXFXPOJXKZ9o3LwpEljUKiqJJ54eYLPn+muXOiERjGvs+aOSU1hqaR3WEGslCNiuGsn7kuIa/J1UYKMrPQrjxogCerymWTU2jxUL2e9ZIIGWXmAfPKCyWg8cUsVcbpng7ZxY7LHQNe24W+9U21ei1qmwATrERONpVmV61uMJv8qXOWqik3g/ugSN2tYOE7nxNr1XYSMmGyzfhna+pLx6um6jOpEMJYW9WvcrofksdX9TiOWhvCjKrepHCoduicpG/xwB8JYAB4E4aYo+IBw+7u5nGKrix5ezk6++JhMKUhgUnNe20utkjHK5ObE+ul0Qy8LyzSslmUpV2+2unbkwG+3YXgsFPVlqa1q1eRp/yJB9R9fMyO+uGu9kMsYY7iilGZrAMckWTPffakBuZC+VHIBlsmq+ofTiY8zWXH6xnve9H/Vyxg+pu9Hi7lr2RDN5VobDL/XTH8zUMupzQKRo7GHaqu0mW4ZydOapf3WOmANozQx382NRiRxdk6kkKonrMaT1Fa3UGVSe14W3AdmZgKNCBmYUI85YKGjCzjxISZOHT0q3W4riq9KUjYXISju0M0TnpV5VREkYv+gIyJ2nX98rUCvXtMrw4MCn9781Bmi9zSXF19n5sMBvJP0TX7sJunLRpNoLM4FDSMb6+9ga1OUOIsVsQbjf7MNJMbTd3hLT7V/Ss4aWo+5ipDEXdZjnsYpA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(396003)(346002)(136003)(451199018)(36840700001)(46966006)(40470700004)(7416002)(40460700003)(336012)(6916009)(8936002)(26005)(5660300002)(41300700001)(186003)(9686003)(4326008)(86362001)(33716001)(82310400005)(83380400001)(47076005)(36860700001)(2906002)(70586007)(426003)(966005)(40480700001)(70206006)(8676002)(316002)(55016003)(478600001)(54906003)(356005)(7636003)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 06:49:21.6990
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c1877923-4379-4593-d076-08db25ea92ca
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000B07A.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB7087
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 16, 2023 at 06:28:28AM +0000, Liu, Yi L wrote:

> > Anyway let's not wait here. Send your v7 and we can have more
> > focused discussion in your split series about hot reset.
> 
> Sure. Once Nicolin's patch is updated, I can send v7 with the hot
> reset series as well.

I've updated three commits and pushed here:
https://github.com/nicolinc/iommufd/commits/wip/iommufd_nesting-03152023

Please pull the following commit to the emulated series:
  "iommufd: Create access in vfio_iommufd_emulated_bind()"
  https://github.com/nicolinc/iommufd/commit/6467e332584de62d1c4d5daab404a8c8d5a90a2d

Please pull the following commit to the cdev series or a place
that you feel it'd be better -- it's required by the change of
adding vfio_iommufd_emulated_detach_ioas():
  "iommufd/device: Add iommufd_access_detach() API"
  https://github.com/nicolinc/iommufd/commit/86346b5d06100640037cbb4a14bd249476072dec

The other one adding replace() will go with the replace series.

And regarding the new baseline for the replace series and the
nesting series, it'd be nicer to have another one git-merging
your cdev v7 branch on top of Jason's iommufd_hwpt branch. We
could wait for him updating to 6.3-rc2, if that's necessary.

Thanks
Nic
