Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 606885F79CD
	for <lists+kvm@lfdr.de>; Fri,  7 Oct 2022 16:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbiJGOkB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 10:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiJGOjt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 10:39:49 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 977652633
        for <kvm@vger.kernel.org>; Fri,  7 Oct 2022 07:39:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JgoU/5H8RRxlhXAJOGWoXzGbKv89LSJ9ScVIAXqQf2f80C6i6zNmd76Uel8dhBCvzJMZK4gBYAFzRxqjKsuQJ4nrWvYNjyk3Hp8YSZ+8T1oNsKU07/o+MFdBqjZlwlqLM209+pDpAWK52CAziSzs1kjlsPnc1jLLgFAgSW7CDgatvMN0OjzSsOTafJFs5SKoAI++ZP6wRfGXFjI9830T3FPymPc6cViA7Rzim+6A7Pe0KMqqntrRuUj06ZGIoGfXMETX2XbTbQJsUs9pYPgFJRHpZsmLnOyseoyTk0mT0qa3+luO1fQwmeO5Ram6fGVKiq7a7zx/hL7SQyULAms56Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0ErN+q3zP/ZmiTV3VGvQHDIcWDj+DqQ+eeL63KQQ4uU=;
 b=JCH1krm7FQh6Xr+RDqiwy71spOQYmm6CNDBZmo/AYgErMCEeVYawMgt1FM4Ez2WvjG7LbZHMG73dUU6V1LI5pt5+RjZ98zfWDsnSmhRSreN0qp2bHPagetCBGBzFgdxMmUQavB2bUrhnJk3MbfFvbmGYBsxlsB8xgD3OimmDHlLWUGC39XahC6FjtSF9loTbWo8HJ6+Xi/nTlIeqkkefeNkPYlVG7DkLiMhAB0QmhhBI9d2j5i3ZiJsRS8fpCRQdym1G+1/e12dpW/x99A0oVjZZ6UIGrekI9NuY90n/+yReRg9gdzwv+/McEG43CZFPotX5imz1YUW5wI24MLonUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ErN+q3zP/ZmiTV3VGvQHDIcWDj+DqQ+eeL63KQQ4uU=;
 b=RlXpa5rbmAzZ+clnVlwMKO7sPR0+gSap674oqB4TNEjwuSqTgP0QTOi1DHFl7FqPQm40vyD7aWebxNw5BTautXAO2DfNP0MUwzSEuEI4n3TsoSyN83G1tQPJsUlvAxsxkWgKWDybJFKa5dHR5pIWvJVAKJ2TqPMSbC0YDHfd1h9a/Wh0I+X6vFYIrgBk0aCP/XC18BHkwCeU6cWg0PYTEEUl6obxd9HcpUTfjZ+iAcOHMt2aMUlSoN70cDXROj2HoRHlwhVEI2wq5J3uh9B+ywMmiSXK5Vw0BeALlDXwS0L8/ec44j+MzbMVjWaHO0q/uTIhTST2NJs+LZUExwLcwg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW4PR12MB6897.namprd12.prod.outlook.com (2603:10b6:303:208::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Fri, 7 Oct
 2022 14:39:46 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%5]) with mapi id 15.20.5676.032; Fri, 7 Oct 2022
 14:39:46 +0000
Date:   Fri, 7 Oct 2022 11:39:44 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Qian Cai <cai@lca.pw>, Eric Farman <farman@linux.ibm.com>,
        Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH 0/3] Allow the group FD to remain open when unplugging a
 device
Message-ID: <Y0A6MH0Espv2JFWu@nvidia.com>
References: <0-v1-90bf0950c42c+39-vfio_group_disassociate_jgg@nvidia.com>
 <20221006135315.3270b735.alex.williamson@redhat.com>
 <Yz9Z3um1HQHnEGVv@nvidia.com>
 <2a61068b-3645-27d0-5fae-65a6e1113a8d@linux.ibm.com>
 <Y0ArhhCOXEYQMC1q@nvidia.com>
 <b04ce2fd-2c68-7b0f-ec43-3f0c27d35c0e@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b04ce2fd-2c68-7b0f-ec43-3f0c27d35c0e@linux.ibm.com>
X-ClientProxiedBy: MN2PR07CA0012.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::22) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW4PR12MB6897:EE_
X-MS-Office365-Filtering-Correlation-Id: d6849d0d-059d-4cbc-9e51-08daa871c7bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o91vjo5f4p46xSRQtOHDL3TPqLHtpjKz+6NlsjZO+JoH4JMPhBZ60epi7x97G5w2THoPKH9oDK6G2kWN0e9wds6YNOdAZ0qTDwZpelhOHNA/srQws+52fvsqeJATSIhI3e+vhYHTi6Qctqfp+ITfrKjG+d0AFL3Ijb4jM1Z6MVOMA8qIcatf6QUpEJKpNC6uQKZCQ7h+O47KtpN8C4876T/J637xNnsjL71LzSaMGmF4qUYmPovm5aT4Hd2dPwIbtZF3dCSa/uIeXueFS/WH3aCwi5TDaXcVSSM6hEFXRhfZkwAkcj9VANN8VHbXlxCFTLzF9iPUfwv5JUtQPPMKB6gM+Ch5tvNTCUvZm49Fw3+/1FJqv1kzEMZsiOMZ6yfCzyrXr5CKM+uOKK9CsXCswKhyJAOThaINPBzQFVnZGLCVCHlPmUxpCNtNEj/XBKL0QnTS/5nTm72RTaoRd/HTZen+3nfT7l+5WRkMIk1x9hRlbGJfDGd+2/r/jCH/iPo0V/g4i7+gtfqxurkxXc49h0FKvFuYNRjgFaRq7tNQbwsyqO6xfe/5u4EY7vbP62AKm2zUuBOpccpT8e1hymVO8vvHQCiKWMvaMgFKTQUvz45ptZPQwQPB7fUYfwjLAjR3YKnu/dJSyFQXqftHkkw2UflBryY9FWRmUlEIxSObiqOqC1GBAnxUE+tPrbXJw9l1eZN5LTUKM9XOmNcJUGpH0g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(346002)(136003)(39860400002)(376002)(451199015)(36756003)(2906002)(86362001)(8676002)(8936002)(186003)(41300700001)(66946007)(66476007)(66556008)(4326008)(7416002)(316002)(38100700002)(54906003)(5660300002)(6916009)(6486002)(478600001)(83380400001)(2616005)(6512007)(26005)(53546011)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HP1k27aPE62dKvPLBDrM9dkIVBhmSbk2pZ5IvleAqj+8OgzHrdfPEy+azp46?=
 =?us-ascii?Q?lvl5flgJL07Ijx1aO91raHt2pasEgkmy8b9IJrjCnNXSBvg5JXSqXv9no4F7?=
 =?us-ascii?Q?s1WC5o1snBHEeBabsM/q5eDEgcVpmMJT6nbYJcKBMRNSS0U5Id1CI62IPqz0?=
 =?us-ascii?Q?fVCDbg7lxyLFVuJhZ8JXSB4uQiabXSmLn7xK8zR/fYkkdqaNc8sstaULSbtK?=
 =?us-ascii?Q?PepwXQS02WQ4cIHKpFwerXOHfccnOS8gvmp4I9G+WnSBpzcb/zyOjEL3/ZQt?=
 =?us-ascii?Q?Z4jc2bKloqpS70h/zWT1xvUZB9lz7PXdb+eLMiPSDAWXIaB7m7NrO9V3zxxG?=
 =?us-ascii?Q?GFVMzAsHyn9ZTOpPkWUw389X0g7U7hO6cfBj3GMdxVNPKW1b1D2gz2myC850?=
 =?us-ascii?Q?Of4ncvYejiOMKIqCit2fkFsxbxioN2PrhhP+01eHHEdgnLiQnbRE4OhLC7+R?=
 =?us-ascii?Q?U8iSWDP6Y9OkH9lP5ZKBDD8jKDEpVzQGarBxadso4F3YvUxZd8Nys4X42bIS?=
 =?us-ascii?Q?ZuClshKMOnaOBd/lPjLRppV7NnOejB2FV/aN55MdF1+skbdrtBYyD4HVJYf3?=
 =?us-ascii?Q?T6qfZxZclQLzya1YvV1KH7+zQxkfupWUeyaS6MbR39EoGLyPF9Z9yJR8ad86?=
 =?us-ascii?Q?euk+DF70jqAdNNENI7x+zV5g1xYMdfRMNyKjiXhzScSVgJWsoihc5D82kZ4/?=
 =?us-ascii?Q?tjyfQORjxC40jngDh4KYXVx1IiR3Jr43armMu1pxATn+T7LGPsRK1CsZvwDP?=
 =?us-ascii?Q?UtXEYdMOeXo/DlATNpY+40Lyq58Vg8aXugFXd6nIuTL4xT5ak7cZ6YGhtl38?=
 =?us-ascii?Q?xXH1pMgyzfAiq0qJ81FkXoqD8T2uYAaiv816oVu83/LSVz/AdmMYgTGqK2k/?=
 =?us-ascii?Q?q4tyeAd8ogfGubQ8j38q8b3lSRSQqgo9stCwRt5HQ6kxZy+BBQG5rY/EeslG?=
 =?us-ascii?Q?GEMijpTt0DQUmQR3Hfztl5oBeEdSLRJoovsqWRiZIaJbYbhlGvykjIZoJ9xd?=
 =?us-ascii?Q?FVoOpSk+pOGcgRoilYEeuynkLiE66BGYTW0tU4wsn6FH9AY+lr/3zmqdzJ3P?=
 =?us-ascii?Q?kbxLhwXgHNYmnz+0wcZ7ZHd/pU9mNsrNVMO+FnZIuoU8GI1f0pGO70zJy8IH?=
 =?us-ascii?Q?r3uA34oAJSD3rlV3If5DKhqTrlStCcqtaiVjtL/9KZT8qJ9oAcLipOvKm6ck?=
 =?us-ascii?Q?3ypZm8hzyeI3g/X/ZneXPeU5BCFPViw8VXmj37/x/dNlXjkwFzFFE3KEc5im?=
 =?us-ascii?Q?XyNm0NjBOoksa6/J3UbwCmEkMNDy49CC4Q0su6xkwwlFXg5Qpv5Z6g5Ju4jA?=
 =?us-ascii?Q?wgFCiitaWSN8PD9xCfgwDG6fpszw6XqboVu/gYTG3hfZ228gM/TpdwnqvcE5?=
 =?us-ascii?Q?Q+XY19bLV2dUV8r8cfSBfUGGkFJWlBa6vkydkgT5sAinH+RSbOAsfWk79BZs?=
 =?us-ascii?Q?XPX+oNkfDZesl5OS04RPtgQU7DB7fUHVH8LZ1xWR+xDD7j5YVMQ76a/6SgKi?=
 =?us-ascii?Q?kwve1X29QoCmRyQwvV3+KrCgnVskTUWomUZBjhGh56+AsTzeillO67TpedyA?=
 =?us-ascii?Q?cEWNh6h0Zlo6TNpFZXEIlq+aCkZpL4S6YaDKtels?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6849d0d-059d-4cbc-9e51-08daa871c7bc
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2022 14:39:46.3706
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8HSwG1vSzc5QEDzdFC02NnxNwEWN+K91c/cSy6Hn+qKMe9VPUmszPUZ6xZnRwN06
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6897
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 07, 2022 at 10:37:11AM -0400, Matthew Rosato wrote:
> On 10/7/22 9:37 AM, Jason Gunthorpe wrote:
> > On Thu, Oct 06, 2022 at 07:28:53PM -0400, Matthew Rosato wrote:
> > 
> >>> Oh, I'm surprised the s390 testing didn't hit this!!
> >>
> >> Huh, me too, at least eventually - I think it's because we aren't
> >> pinning everything upfront but rather on-demand so the missing the
> >> type1 release / vfio_iommu_unmap_unpin_all wouldn't be so obvious.
> >> I definitely did multiple VM (re)starts and hot (un)plugs.  But
> >> while my test workloads did some I/O, the long-running one was
> >> focused on the plug/unplug scenarios to recreate the initial issue
> >> so the I/O (and thus pinning) done would have been minimal.
> > 
> > That explains ccw/ap a bit but for PCI the iommu ownership wasn't
> > released so it becomes impossible to re-attach a container to the
> > group. eg a 2nd VM can never be started
> > 
> > Ah well, thanks!
> > 
> > Jason
> 
> Well, this bugged me enough that I traced the v1 series without fixup and vfio-pci on s390 was OK because it was still calling detach_container on vm shutdown via this chain:
> 
> vfio_pci_remove
>  vfio_pci_core_unregister_device
>   vfio_unregister_group_dev
>    vfio_device_remove_group
>     vfio_group_detach_container
> 
> I'd guess non-s390 vfio-pci would do the same.  Alex also had the mtty mdev, maybe that's relevant.

As long as you are unplugging a driver the v1 series would work. The
failure mode is when you don't unplug the driver and just run a VM
twice in a row.

Jason
