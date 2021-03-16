Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 331EC33E0C1
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 22:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbhCPVp4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 17:45:56 -0400
Received: from mail-bn8nam11on2085.outbound.protection.outlook.com ([40.107.236.85]:35168
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229590AbhCPVph (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 17:45:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nICZx1FGW0kkHxa30QtocLcztAdlYPCZ5D1rcDnLIxBuM6fbamkP49eXhqwVyUqzcCiP2syjC1NHOTuZPtaT9gcgsXLlfDW4FcgeSBl4tLacuAaKAZO4OEdEVoySeu2aUfzSMNeUl81o1uVAvXjPE5UIUlUBNQ4rkQodaZjt2R6bBHzLSFl/z8iW+uQEdlnlgvcZ3XsAwKpu7da9TpiA5gLdo0qFjr7y4Zkof4p3aberhn82IjWYJFE3Nom9XF/UUIjt4b6hRj6RIHORARORguFWeX3h4T+ZZvXOR6AjHoLhWdF9YocO5GSWH6GLFFmAEsEm+x5zQKi4OabUxTBpyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ERr62gBoaH68mZofjvNxesdzcI1CS/hkgp0xQHSO/14=;
 b=jldeckcx/Uw9zjjJ1VA4SIhsjlJ2nbpU7i/Fx40ulsR5SlBpkwgjIk27fNIZagf6A1yanS1oXcjbRT5YCKIRqWbRGod3P0y6+Htjz+CE/bjRYCqOUSWhNPsBrmZy4rXftT4TMft+7n0ftXx4XJyLbTtRZqUq2dI9tCRnQ9kAgh+zlmg335SmrSaVmrXMv5LbhDsF/CM945VHxy2HULt5/qMnecVS+IEwQ9P3HoCQcOdzEL6t3lyddDnsQuhI5BWDZuYlC1hwvLrFKLukE+6nzYaARFbTSJVJ61KYZe/W2wAr3U9J3l/18aEmreYbBAyf8ZEGF8+TINuFvetEmXfPDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ERr62gBoaH68mZofjvNxesdzcI1CS/hkgp0xQHSO/14=;
 b=dkx5x/EL2/FkB5nnY3NM4mXk8oIEQe3Z0zGR9H/Hfwj4mWxEBcl13dBNyJ/MwuT7XnY9UDNvLdoH9uztUt9tLJMOX9YptsB/k9yXl7dATlipjtJZG3QEt3kArWb9pkQ//7M/8liPDuWiyvSTWGt/SWWrOG/yxDh9Vp0EuS6MreXkY7vcPRb6TYXye11Mhft3lXonBscB2mYCESlLpYirWld7Ss9WecJCD8HJvp1RMYgjTsBWMJ2CuQGe+h7iPGtqSjBb1dldC0nj/HcYPi8brxY8x9LlAIHhyfVa7CnVikGn+DJ4hh3LCbS887xNg3Oj+CG1J3MnYwFe13ExhRzVJA==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3833.namprd12.prod.outlook.com (2603:10b6:5:1cf::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Tue, 16 Mar
 2021 21:45:36 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3933.033; Tue, 16 Mar 2021
 21:45:36 +0000
Date:   Tue, 16 Mar 2021 18:45:34 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH v2 04/14] vfio/platform: Use
 vfio_init/register/unregister_group_dev
Message-ID: <20210316214534.GM2356281@nvidia.com>
References: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
 <4-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
 <20210316153355.37c61a54@omen.home.shazbot.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316153355.37c61a54@omen.home.shazbot.org>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL1PR13CA0344.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::19) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0344.namprd13.prod.outlook.com (2603:10b6:208:2c6::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.11 via Frontend Transport; Tue, 16 Mar 2021 21:45:35 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lMHVO-00Fuii-7H; Tue, 16 Mar 2021 18:45:34 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 49a59344-c817-4aa6-1d65-08d8e8c4d4ec
X-MS-TrafficTypeDiagnostic: DM6PR12MB3833:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB38333AF79346CE21820EC71FC26B9@DM6PR12MB3833.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qcnI7cSjnKHmY0YLSLaMWA83O/BMRbENd0t4p7BeKSPlxAeU2WTQPtp9CX7zUn3hid4LDJIVSwleu23kM4OD3mCzvM911N78Av1pkhykosfuNR645rYNG0+xNbDYscfh6LpLmSZYQg3Lll4vYTUJvzXsXYj0wIR5QHfxB9T4vtnXxlj2wi4Pj2L7uz+8NKVgmL1U1ewG2kyCq/edJFWN42Ln5KAsTImUplzQh37mJ6LegSeFAAlFAa0rI5RbEQ4hqNSNQVTa30ZmrPwT3LwA/m8gpzJU5zgnnTz97mTeYZasuU8ScQEXD0XVe0aDxCBMAgdTbmti3IOVP54sYnAgMZiy2+/5BFbomAeEetcwyseZoNOss7GauIaq1pqH6jfb0qkm95seDm6SPIp/WPPkidSmecCjTHDd6lPGaSOm8QoQKLWWNB75l4GIKZ2YhsHJRSYZdGXKkygonuUkHwnuDHmIA0zFrq8NcvvGJQIlKuoEFtkq2jeru2KOkeVcLdpO48CmISVg/Yy76NfDwsavuZ7rFM2MpLqefYQMWiAd/z4h3cK4qYHAobV8km+nKB3p
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(366004)(346002)(136003)(107886003)(9746002)(9786002)(2616005)(8936002)(4326008)(66476007)(54906003)(66946007)(66556008)(26005)(36756003)(6916009)(186003)(2906002)(5660300002)(8676002)(478600001)(316002)(86362001)(1076003)(426003)(33656002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?oY1txUsiZqrnzj5fsMD1awKin6rvBBVpa/ykercpGCKaepoN7IBb0DOCg544?=
 =?us-ascii?Q?Um5vrxem+1jju66ACy3p9i2nwcKgBFgnl3EEEsnR3qZD8WUkq+Zwj6+dHIZr?=
 =?us-ascii?Q?SICH8YxfFJArrMR2I6eVoHxdrKnKWGDMtgugQjADlPbpTmKucV3t6oCTHOQG?=
 =?us-ascii?Q?ZsxDUg0dNm42Fc+xPoRHE2sFgZJsXXGpk/gl8CmXtK7rX2L1qcYYT00TMw4T?=
 =?us-ascii?Q?Da7cuSbK5jKTjZ744woqzCLqQEswQ5GJLC+XydTaUtmORVhTmorfokyO8y1D?=
 =?us-ascii?Q?A8biXz18NSOdCbfu2Jti4EWLYkOnbo3pE72PCaNFCCkiUYDjKc7U9SYA1a1j?=
 =?us-ascii?Q?MsHJ5Hm4EUIjwA7YQ2+eHNYqYKuw061GOR5DUvLz79avKFQv12dzyxHfUpum?=
 =?us-ascii?Q?N29PLMD3HWxeLJtlZwT7aR4LzVzj4Mu8SwQ+EKjcGwlr7Ra6C+jFEkJfuTfb?=
 =?us-ascii?Q?t/auOHAfDYIrcvyXcqwT/31uPiSi4kBVS4G5t4+dOdvUrPhvLz6t/OD3Krsy?=
 =?us-ascii?Q?NLTpXRkzptmYckZKkciEatlrFJ8aOM/sZCGCDCEtjTiG6Yd76E7CMlwyGr1T?=
 =?us-ascii?Q?tn0lHsi18WDmRuUL0lpwj3HdvCW1hE1WcY1fuERhFnuwteE6Z41++k9EowHd?=
 =?us-ascii?Q?Fxa+JLMru008yaHSy7AZkLe5dJ7OplkMHEXO2Uqf50wwB2lJaQRoUtBBMf2y?=
 =?us-ascii?Q?qsOw8H1vTuukZ3uGu8091QD8vhiQzCd3Wrxvq4eGZ70nYsfY5rgb5OA72qpM?=
 =?us-ascii?Q?/vSFLSmlZP6Nw/zF7WJKTq0zUMu+MGOtJyos6FOY3E+lC6xEO2GY6o3gI8ug?=
 =?us-ascii?Q?K1+DQB7o9QYpxUEMBrWlTcvkYyW+Da4fAhJgxlxTFB1eULbLKlSXCiRfSyy6?=
 =?us-ascii?Q?hsZrT1ROLcSZZnbsr3eemIUZvYkCrMghCMW69n3w79bc68Ba0rbaqpncYj16?=
 =?us-ascii?Q?vqexZNPDeze/sF0kZZE9g2fvTa1pempMBakFylvrFowqWVrnu8ZPCNEduifN?=
 =?us-ascii?Q?YtVLe9WAUItV0JhtCCKqCDv64yPhE9yGIlu6xfv7uql+iTxhbUavb2yMB8dl?=
 =?us-ascii?Q?f2oXUv2VEQ/+7ZmSjPPLpao1jzhcNpWS/8fXFRTfUAVtqpq7be6fWqFMZxQr?=
 =?us-ascii?Q?DLuQieefuouME3gbhyjSHj/S1LXnzocP2hSFNlAXviDLbso6wZ7UMTK2HTYH?=
 =?us-ascii?Q?dOBlMvw8zS1f59+BdtcHvaIAuP9DvaKRAqslfUR3SDtxFN4YwNll4xbruGu0?=
 =?us-ascii?Q?BqIftbVCuaf1U17UGPs8grtulGwbaBdFebioJRjRGr2yJL/L9w9tg6RGRVoT?=
 =?us-ascii?Q?vfK9GtHkz7q+wQVe8r3ciiAv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49a59344-c817-4aa6-1d65-08d8e8c4d4ec
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2021 21:45:35.8771
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hc9+QRf+CMNbfc1jJn4ySVw3yH17iZ9uLK5cIW9VT5bCWFlRPWx64qMrkKRKea76
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3833
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 16, 2021 at 03:33:55PM -0600, Alex Williamson wrote:

> >  static int vfio_platform_remove(struct platform_device *pdev)
> >  {
> > -	struct vfio_platform_device *vdev;
> > -
> > -	vdev = vfio_platform_remove_common(&pdev->dev);
> > -	if (vdev) {
> > -		kfree(vdev);
> > -		return 0;
> > -	}
> > +	struct vfio_platform_device *vdev = dev_get_drvdata(&pdev->dev);
> >  
> > -	return -EINVAL;
> > +	vfio_platform_remove_common(vdev);
> > +	kfree(vdev->name);
> 
> 
> We don't own that to free it, _probe set this via:
> 
>         vdev->name = pdev->name;

Gah, yes, this is a copy&pasto mistake from the amba code

Thanks,
Jason
