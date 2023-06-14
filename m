Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 184D773003D
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 15:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245019AbjFNNiC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 09:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231814AbjFNNiB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 09:38:01 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2061c.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eab::61c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A4EE183;
        Wed, 14 Jun 2023 06:38:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J0JiXoJwnYlDg82404zIyBLrkddidzyAjOZPznlb5oUQSTeS8JF88lnn7/n/nWmuc8cZXXl1QaTdl1ioqO9FiYlFOz/O+v8LBJTb52q2ave+IJMacD4QgEIs8/hgvV7ra+rWF6iamKdfA1lQB0zWHzW4WUYjlUUI3r+pcoLdkrsRW/gbYgNOfqUB4lYLzi4l5/2plWf2xySwe5B+XFerUhtNN+Zq/RQS8XObTHRuGXj5Q1f9wRm/SaYn4dpaLJLF73/MC7RJoeRPKuKHAWiJaf4CTnbxWwDpBx0eCPJlEUEK8zJvrq/yIS4PSBoLjUKwMnY/kWVTgzWV8QWZNSEDUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WEUtVcWVRmmr9IVaOkIPosdH5/X108EXhcHXf+9cqdo=;
 b=ill2DfPt2M1691DJWKyVMHHMRxEKN9/U1MQAwjkV81hWsFUMUuHCgBmT3kSzKtoz9y/2mJCTxz3jya3H9RlHJC6hsHtCHrU1phy4lT/QlvkEAPoOKEaRLfxI0Mm6es3RJkUWs+L4UOvj+haeSlR00rp+87LwdTfnF/ms4LpPw5qXV0MADHTu81Tr3TrK4sPxlG8Gn2/Cir/YPPsE/NcUum84Ud/TAhHu2CcshaElNtKXPEWUqppTpU/j0mkQQh+07t6VZ+TSInhixShc2wtaT2YxF9JSTp0Rz8+Gqj/IEc4nWbWSOKWa+byvtAmxYB9HUepVH8di7uo+lHjo14y1Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WEUtVcWVRmmr9IVaOkIPosdH5/X108EXhcHXf+9cqdo=;
 b=R5dqcF+kFqXrQeUPdhi8cbRI3nSpzTXA742OFT3j4HJXrPI1e0OvhZbTDWmaAyrW8hds53n+Aufkq6SLGJVKaweGwGzUy1jAJEGGw+InhvGq4PrICMXFm1Dv6MdZ2FQO2JDkBNq9wo6e/tkl5k4WDx1S9Yf/tdWsJBshHAqkQFA5G4TuPj0mIa73pw3/qE5pamuo/wPaKjjDQtsvlTy0Z5R9IdPuzms2H2h8MGOeAj9ixDFAs+aqVsEPJgntZLOOHnlB4vOuD6otrwWiBLUVZdWQvjkef58INp62RzRv4oUMIhfnOw0Q7Xbw6TPKQ+9+E1nWTJbcRgaUl92vkyH1vg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA0PR12MB7553.namprd12.prod.outlook.com (2603:10b6:208:43f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Wed, 14 Jun
 2023 13:37:57 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%7]) with mapi id 15.20.6477.037; Wed, 14 Jun 2023
 13:37:56 +0000
Date:   Wed, 14 Jun 2023 10:37:55 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: Re: [PATCH v7 8/9] vfio/pci: Extend
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO for vfio device cdev
Message-ID: <ZInCs7augGxSzWYp@nvidia.com>
References: <20230602121515.79374-1-yi.l.liu@intel.com>
 <20230602121515.79374-9-yi.l.liu@intel.com>
 <ZIi0Bizk9qr1SgJ/@nvidia.com>
 <DS0PR11MB752932BD50E4F73FD7982DB0C35AA@DS0PR11MB7529.namprd11.prod.outlook.com>
 <ZImv2bl1COqA/8c1@nvidia.com>
 <DS0PR11MB75291989A5508781BB471322C35AA@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DS0PR11MB75291989A5508781BB471322C35AA@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: YT4PR01CA0203.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ad::28) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA0PR12MB7553:EE_
X-MS-Office365-Filtering-Correlation-Id: 35499312-e17e-4caa-eee9-08db6cdc9007
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8mSylLWSkZ8L2oJ7j+rZhk5Z3qbfBNmNPJ2dfO6Pl8K852FbzcJa3Ih8iizrEyh/auyMhyLAC1Qoh3+P24asj3OwIEnCsmy662Ymp7MTmSeRfy7fqQouCA+4fVQNM8Eo8v6Z5iiI2xj4ifqW7ll3J6rjwbTP/0zrCALmbaqu5TZwh+mhwMZVara9uqFUIsBauLGeI5pvrvLMwvbPtzg/WtTIIuIfwzlrxmPXcgg6yxX4fJuqi2q6NEFa1X4aaSBCtN+nHzUkYaGDa3b9GVd8AZWYuhU+SeqpXxMjKO3s++jxfw7YP9/baUjQ7cp1DNI4T9ZKguni+ALW9xhum5BNdSeM8JlbZrtoYEsVZUa/xJ2SIQT2O03lae6q4sMAigubzwrgoSFMUu70A0HBbR1DnZB787sgkLDFRU2AurkakqAPaDEFkGhOsgGjhVl6aY4SLDgh1O8X8KM5GH4HYNvYzm3jx4TBF216IqKWUcEfq0pP6Wre3USPus1CijsXhcWjrEg970rvStqv7uVvZgxLWD35ZR6NhFjfArFPyjgBbwBkLT0lI1pj6ZasbMCmkM2s
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(366004)(346002)(396003)(136003)(376002)(451199021)(83380400001)(5660300002)(186003)(6506007)(2906002)(2616005)(7416002)(41300700001)(6512007)(8936002)(26005)(8676002)(6486002)(316002)(54906003)(36756003)(478600001)(38100700002)(86362001)(4326008)(66476007)(66556008)(66946007)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SjhwM0l2VUhYZDloWFVqd0NjM3haek9TeGYzOXJzUnZZeUFSSFV3VmljWjdI?=
 =?utf-8?B?TWxlQnJwR28vQ016Z2JXK2tIS1R1TjZFT2FrZmhOYmpjbjVxY1BRVkUvYWw0?=
 =?utf-8?B?ZDg3OGE5YmFOTlhtTi9UZHIwajZkRi84R0M3b1NHOHRUMkdFeFBxQ045ZU9h?=
 =?utf-8?B?dXhLZ1BPdUxjYmNCMU9uZ1dEL0JoR0g4L3JPRTNBZ3VVYldGN01TdDVMWGpG?=
 =?utf-8?B?ZlM4eXJYbFdkZTR1RDNuUGZCeVBzaXE4RzdkSTBObUEzRWh3SVVQRXdNOVRu?=
 =?utf-8?B?M1VvbStRd2hRT3I5WVVBRkxsQzZQMDlsZXJ4UXR6b2NoVStJMGdKVU0rMHVS?=
 =?utf-8?B?eWJWY0hwNUtCMGRxK2U0d1pmeEdoZWRoZGE4R2FQMktNSWVaeUt6bktqVnVI?=
 =?utf-8?B?TDlGazJDbEtNTmE2cnFtWTlDUHJvNTZheWRPdmFkL3pXVmQ2RlEwWW5OOHNP?=
 =?utf-8?B?VlAxOW0vYXB4NUg4cnlKbHJrelcyck5yS0RueEdYR2kzbGZhczBXVFY0WWVN?=
 =?utf-8?B?TktIVHVENGIxVkpkR2VVaHZzSWdXekU3M3JNQlp1amd2eHV5Y1p5YTBOc0RW?=
 =?utf-8?B?TjMvNFFzMXUydnlqR25xaUg2N2R5RTRXekYzRzB3alVmMkFRMklkOStuM2hx?=
 =?utf-8?B?Wm80VGdQZ2NsNThnbEgzbno2WGUzb2tKVUI3ZFpxKzZ1ZDVwVDJvTzdaYmQ2?=
 =?utf-8?B?eFpWeUZYQlN2SnNkRHhqR1pyKy9ZcUlJM095WnlZUWpUVUlMVVgxODg3amlE?=
 =?utf-8?B?QTZPUFJjblJYOXdDT2MwM3dhMVJ3YnRUNUlGUmN0QTRYcWxUWlJFb1h0S2xm?=
 =?utf-8?B?TkFHalk2QVdwc2dZTlRMK25mTDFlWE1SRklZR1htNkt0cjNGbXUzUVRpcU1Z?=
 =?utf-8?B?Wm4xLzFLSVJudzFOYjVNc2tPMSszWGhyTTAvamxSbnIvbnZFWE1UaGRSYVgz?=
 =?utf-8?B?bHdFYmpSK05VRlg3V0xKMSt3ejRLRzFlb211d3RJUGdtSGlPa0dhSXY5ZSs3?=
 =?utf-8?B?cW1zV05QaVNkUDNSV0k1T2V2Zy8ySE5iQW1hVW90eUM1ZVBzR1dsUmZKa2x0?=
 =?utf-8?B?NVZaNHg5Ly9tQk1rVG11MGFOcnZvSlErWWRpT3UvRXFQVW5hamtndjIxekZS?=
 =?utf-8?B?MXhjOW04N1RTYVRteGpHUFY2dVFqNFZNZCtOazVsTGJxMGxFVHVzY2lxazl3?=
 =?utf-8?B?QkZHMVV0Y0RsUlRaL0poZFVpNEJFN1RISkxlUmtsNERaQW1JWTB4bEFXM0FT?=
 =?utf-8?B?Z1hOcTV0b1RQMjh0eG1yTG9taTFxcTRxSWc2akZ5dVdEc0ErL1lQUld0ZTln?=
 =?utf-8?B?V0FJMUVSSXVFR082MGVCUVlFWVhjU016b1RWeGcwRmE1dUtUcS9vWkJEbVlW?=
 =?utf-8?B?M241V3JMTTV4Y21JMHQ1eTN4RjMwSHBhZHREbzFuK1RCVE1ZZi81bDJIKzZP?=
 =?utf-8?B?TjYralJzaWdJUW9xK1plWnM1bXBLUTh5T1NUWGRGUTd6V0lSR0s5Y1dCK3dI?=
 =?utf-8?B?OG45RkhxTzBDMEFpYkU1aUYxTk9DLzN0YkdPZkxJVnZnSkZkdlhSMXdXMGlB?=
 =?utf-8?B?YVo1cU9ETWNxK1FCdysvcnJVaVpVNU9hcmR4Tzk2V2ozQTNZZnpDbkVwY1Q5?=
 =?utf-8?B?ZkFENzJwVjdSZDg5akVHTyt4dERZRmhYODFnZG5CY0RxWUZYb0c4T1oza3VP?=
 =?utf-8?B?ckZsQnhTWHB1L1J3UGJGRTI4UWpKSFo2QStZeHRCQU1lVnBEWHFnbkZ1MUVv?=
 =?utf-8?B?bWc3SktNSEdEanFiUWNvK21mbEx6UEhZRXN5ck1KamI3S2RCdTA4bTJJNzFT?=
 =?utf-8?B?c0xNcnZHdEh5eCtIS0NoNERJY3hWNC9GS0Z3ZVQzb2cxTk5mcDgvdm00Sk5U?=
 =?utf-8?B?VlFvaXl1VkZCMDVXTVVmK05mMWNqRmZzSm9PRlJzNEl0OHRjWXM0SUt1OW9L?=
 =?utf-8?B?K0ZtRHVxdUpHYmhjbS8ybC96VE5XVEc4c2l4Z2dYWGFGa3F6STIxOWRwM3k3?=
 =?utf-8?B?VWJINnhBdDluSEw1YVg2aGlIWDBJVDZxUGVSbG1rRU1ldkltb1pEWVlDTDRR?=
 =?utf-8?B?b3ZEOHNoN0wyZXkyc1ZkSHVpUk1nM1J2ZFlnUnBCMDZxWlYvZHZPOStlbkVO?=
 =?utf-8?Q?A/gAOewwdhkupqp8sCVVJcceL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35499312-e17e-4caa-eee9-08db6cdc9007
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 13:37:56.9288
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x/Ken0Q18pukW91SfiGUnCAF/Juyp+mYYq1zs++JBHbl2J6HJFXtyY0OIoCBWzMO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7553
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 14, 2023 at 01:05:45PM +0000, Liu, Yi L wrote:
> > -EAGAIN basically means the kernel internally malfunctioned - eg it
> > allocated too little space for the actual size of devices. That is no
> > longer possible in this version so it should never return -EAGAIN.
> 
> I still have one doubt. Per my understanding, this is to handle newly
> plugged devices during the info reporting path. I don’t think holding
> dev_set lock can prevent it. but maybe -ENOSPC is enough. @Alex,
> what about your opinion?

If the device was plug instantly before we computed the size we returned
ENOSPC

If it was plugged instantly after we computed the size we returned
EAGAIN

Here we just resolve this race consistently to always return ENOSPC,
which always means we ran out of space in the user provided buffer.

> > -	kfree(devices);
> > -	return ret;
> > +	if (fill.count != fill.devices - arg->devices)
> 
> Should be "if (fill.count != (fill.devices - arg->devices) / sizeof(arg->devices[0]))" 😊

devices is already a typed pointer so the compiler computes the
/sizeof() itself

Your version  above is needed if it was void *

Jason
