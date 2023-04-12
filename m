Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 245FC6DF956
	for <lists+kvm@lfdr.de>; Wed, 12 Apr 2023 17:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbjDLPGG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 11:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbjDLPGC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 11:06:02 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2077.outbound.protection.outlook.com [40.107.244.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E2964489;
        Wed, 12 Apr 2023 08:05:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WKinpsziUVRY+U/5V4N59MIR32fTjD+Cvm55B1W3xFAySb3hOlxyHvZlMxYJBlWObXH7HK+peY2poDIzxQx6gBmFdzVMTxFp69Ho3jO913NuRQBi/pdk5qBHhluw4vHhUFNfe2fiOvjeZkXMx66KXrqRIJg5AjEasmx/UsgDvTq8eApiWvsTTXPH5E2pn+MfmRyYilvCrWdqTn69RC7P+6cZ5RLdINOfS91+FDfYdkpSdTB9Vfsktad86JGVUHLGM9Faqx8ZpzXgJ5xrWWRKFRTuYB3WD/PvsA+yK9AUcFQPJ2/U0wk4mOV91XfsonY6/kbv93cJ+8PXz9wsDi5iMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nFu8eKSey1iJesURmKz/gOSKp9xCKAGK+u/PyDYLSYo=;
 b=hfkDU9SqsAjQprUK/Q3a3DqBrcqPdoB/ZpNiZjlp/CMy8/hx77LsLpoYXCWrkMfwnJPEWBhCznatDf3WSdU5DJjKnOn4vBc9vLpNr+Ke4SqzDC74tBK6Tnbv4rKP56btiFvpNCprvoxPYesqmZsW+gvMwru/pLvwWBh2my8QnawetvqPR31pl446NZ6Yqg/ds5v+OZNlm3qjzpFtN9xFO5iflF45gxgyvwAgILdk5VFTN2w8Vxs/4Wso8zKjA6xQqqWKBB+FK44plXDnLZ2btkhC9NqkuGONT+2PREX/7TxQOkw7b8pzK3YyLTHU89BE+DuJ73Z2DyLaTNFvKgacRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nFu8eKSey1iJesURmKz/gOSKp9xCKAGK+u/PyDYLSYo=;
 b=RPs107V8yzG653oPSD9A98wY9tQgqospAVQL6rJQ/wZ+43XRduFMihg+wa8e87GzSYPEcjOnHcA1YfokJZ4MAeH37b3zAWb0VmahcWi/i4htfbhlZX6C7judwc+51WITAcQgJ78uIwV4jooLW6ttoAfO36kS7K+sTGzDAdr+4CeM6/0fvAaoyXT5hYFMyWW/nuRatbqnY3XK7WMAUExPhUjn/EdP+eFmx3dPd5fQp+/E+bpeHdxLF/iGD/G/2RBbqTeuQFOxF3CzPF0j7VSehnIB9nOa6PhLAZ4fNbWE2fHPPGUQ7QvL6yfuNpcNfS9BOlSrttADMLg6UVmYjfIAkA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW4PR12MB7031.namprd12.prod.outlook.com (2603:10b6:303:1ef::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Wed, 12 Apr
 2023 15:05:55 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2%9]) with mapi id 15.20.6277.038; Wed, 12 Apr 2023
 15:05:54 +0000
Date:   Wed, 12 Apr 2023 12:05:50 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: Re: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Message-ID: <ZDbIzvawep4Sk+0M@nvidia.com>
References: <ZC4CwH2ouTfZ9DNN@nvidia.com>
 <DS0PR11MB75292DA91ED15AE94A85EB3DC3919@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230406115347.7af28448.alex.williamson@redhat.com>
 <ZDVfqpOCnImKr//m@nvidia.com>
 <20230411095417.240bac39.alex.williamson@redhat.com>
 <20230411111117.0766ad52.alex.williamson@redhat.com>
 <ZDWph7g0hcbJHU1B@nvidia.com>
 <20230411155827.3489400a.alex.williamson@redhat.com>
 <ZDX0wtcvZuS4uxmG@nvidia.com>
 <BN9PR11MB52761A24E435E9EF910766E28C9B9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52761A24E435E9EF910766E28C9B9@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: SJ0PR03CA0039.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::14) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW4PR12MB7031:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b03c8c9-e6c9-4ebe-7537-08db3b676956
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lodt+8ONK6htVPm05/Pmi/xNnoEiDWjQDhOTxAkGDyvaavqi9jgK0o7lXvzaaM5zwnBszRliVI+bU6qmxIylbGDS95AfbbkNe8OvXK2Yjf94PnvvrgfoaDLa9GuwiXe/D0ORB2sTvJhFoVdV9Ph/v5dR67OfRaYH7R81+xnqmVmtXK9q03EnYx9d2aL8oy9312POBsefbEyU6RizDI27J2gI8bAMh99L4U1byth58C6070a1nlkNXA+R+vLTBKXhiJmnQDVKiOIeK6DN9hxAxLDqXjgCv3RFPQ6SKrgqBN7FIKCBdDAv0+4urplAbzo8ZA3Fy6/cfPfOgiPsvA/mjU6w4qEvfv+KEH2UuNrkG3+GwBdMpve3Bv+UVQmYWn+5qYZPfsKZWHz22w+unomVCAtEx3QuQgdXNSWeAT0fRFXbRJkE8I9APBcBX+kdFzSeBRdZ51WGYp49EnTE6aKpRWDmOVqKyTZClPzuVcBd9ayCSKDl8OxdfoJeyMs24PuWzfjzBrCB1/3PH0XaHZTBwATL30tmACwgrIB7Gu4ACqasCsRBlwo/Ft8p3qgmHVbcqxBI6XsLedZDHUPtpKLEmaPSoYhy9GwBPwJkypeFhWA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(366004)(39860400002)(396003)(136003)(451199021)(5660300002)(7416002)(41300700001)(8936002)(8676002)(2906002)(38100700002)(6486002)(6666004)(478600001)(186003)(2616005)(36756003)(6506007)(26005)(6512007)(4326008)(86362001)(6916009)(66476007)(66946007)(66556008)(54906003)(316002)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?E/2jFLFISBSy8eiZM64OSF/3y1KjtSl+DIYAFUKzePjRw6ZMK7cTihwvzEMc?=
 =?us-ascii?Q?FWfd2FKLqZ3Nxb81kDXqGAJEeDbS/Pe4veLLnwU3s3LYShQVgG1RkNsz0xPZ?=
 =?us-ascii?Q?pgWdSGPlWfIiGx8NBTXk88DsyTHxIFlclu+VnKwE6h2gn9SfSIBBEegK5w+a?=
 =?us-ascii?Q?0cQcJjtnteva94DevGxhGBxLDFD5zI0Bbddh5QTF0QU41KG1IuRfEBnYszNM?=
 =?us-ascii?Q?iW0jDf6ON3qlfIcv8fPLqW9gFIzQN9KOIHLJiUKI7YOhen1C4J7OlT5t3oWj?=
 =?us-ascii?Q?jb2yjUfp1rBZHnV4KwkED4UPgbuMLIi3vRp3hW9z38ghRr32H1Ew0RScN04Q?=
 =?us-ascii?Q?l6IWkr8fKY55aQaXLHNdSoF3/pghoKlgIKS34bMb6RGO8RyLbKOH9gltNKa/?=
 =?us-ascii?Q?O6DVG8u0GIcwrmyVYI7bgV7qxXDP4xwDFLzNRzELGkNtQ3F4b4mD5aYkguAc?=
 =?us-ascii?Q?r/VX0OicSxc2Wfe3QOu+pIbep/l+Djzg5VmBOYbT12y8yUq0vi/Chk2wnT8A?=
 =?us-ascii?Q?DX1qJDoK34NRhKOrRqZqbBdLkcBSHh162yl4/PimbmHq5BcpRMw1VXP5kJ8i?=
 =?us-ascii?Q?KcMGZWqso+GMjhM+rm403kA/LdeQR6ed6O2Bczq470CpXDqbqVPN1BRHyY0m?=
 =?us-ascii?Q?ahO7mic4Hdr+IGLu8TDUZyEg5kh2cM3QG350PERDGYI9kNEpetVKpDqy45J8?=
 =?us-ascii?Q?1k4jvi9zkwPUCldsURnWeZHQ0cX0XbqGAw3PIQohEaY7ihxk9Zqb9e6F/wrz?=
 =?us-ascii?Q?rovw615idesP771H+nzojK5P4jmGEG45JiUVyPimZoHeZudhbCD5jfjCvnZf?=
 =?us-ascii?Q?zG5ekBvP4h9MjIfG7/h62mOx2TcZNIzvJ9L24cpx0h1ysW01bom+X8+GuC55?=
 =?us-ascii?Q?EsaHwJf9tV1jXqsK3kMOEj8hcsqw+BHZB6CLSNSpByTMxmHkaj+B2H6GezKn?=
 =?us-ascii?Q?nN+sauhOZ3Lx5Zcbn4SrKbOJElkMhA/UqZV056hTb8dtI1BrwNF4sFoNcj4T?=
 =?us-ascii?Q?5THXErGqkWQNTyrGTATfT4HmY4XW9il2S2fRakhG2M8cLI2E9uJ9rs9KiFzL?=
 =?us-ascii?Q?SPo98zf/rGj4Aiuvko2/zLStTSoetGqiMkgB3a+6Ahbs+h64rnL/mssSIJH2?=
 =?us-ascii?Q?Z849Z3VHyaw7W9krVwgadv/OX/9A4F8HDdor+X2Hp4sYyhjvJfRy6EKCX4Md?=
 =?us-ascii?Q?/xUmvmaeLgGrMhMhqz+Lxl+jb5QMSWSPphNd5TeOHZjD8ZGii6KpoFzNI4DZ?=
 =?us-ascii?Q?o44zhk7rFuMRJA2IdPBokOFn7ZXIyvfwd/3KL3th9jjEz2I4CHRKBVfEOaSz?=
 =?us-ascii?Q?5vy9IougUarNuDNWTorZgJYNRoItks1osjTmUW42Nh7ptm7MPiVUupi+eLBT?=
 =?us-ascii?Q?brUsHuv9UwTJv4NHl+5vZXeuvvycWFIEg+HDhWaHmWb240xaKFcyzJ62Qq+i?=
 =?us-ascii?Q?Vix1skn4C7FxloAXHH4jrg0bjRYK/Tjtpj4Go+/EsKqjjTehPLr9r17ub9cg?=
 =?us-ascii?Q?bbMxjqkQTmDEImksmvt21xurf2zzhTf6oLuLqMaEVdk53ZEvZyKXSuJJvIjE?=
 =?us-ascii?Q?UslaSy4PDvR0M3lX6i0wgkNSsZPVC7KLP02eQfy6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b03c8c9-e6c9-4ebe-7537-08db3b676956
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 15:05:54.1362
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oIxz2DTrXron4Y9JRLy86tVGJ9rOCvqF+0n+Ig/1hlhiVWT0lTCVMFTZ+SdkH0/L
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7031
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 12, 2023 at 07:27:43AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe
> > Sent: Wednesday, April 12, 2023 8:01 AM
> > 
> > I see this problem as a few basic requirements from a qemu-like
> > application:
> > 
> >  1) Does the configuration I was given support reset right now?
> >  2) Will the configuration I was given support reset for the duration
> >     of my execution?
> >  3) What groups of the devices I already have open does the reset
> >     effect?
> >  4) For debugging, report to the user the full list of devices in the
> >     reset group, in a way that relates back to sysfs.
> >  5) Away to trigger a reset on a group of devices
> > 
> > #1/#2 is the API I suggested here. Ask the kernel if the current
> > configuration works, and ask it to keep it working.
> > 
> > #3 is either INFO and a CAP for BDF or INFO2 reporting dev_id
> > 
> > #4 is either INFO and print the BDFs or INFO2 reporting the struct
> > vfio_device IDR # (eg /sys/class/vfio/vfioXXX/).
> 
> mdev doesn't have BDF. Of course it doesn't support hot_reset either.

It should support a reset.. Maybe idxd doesn't, but it should be part
of the SIOV model. Our SIOV devices would need it for instance.

> but it's presented to userspace as a pci device. Is it weird for a pci
> device which doesn't provide a BDF cap?

It is weird for a PCI device, but it is not weird for a VFIO
device. Leaking the physical labels out of the uAPI is not clean,
IMHO.

> from this point the vfio_device IDR# sounds more generic.

Yes, I was thinking about this for the SIOV model.

Jason
