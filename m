Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62EA13558D7
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 18:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244082AbhDFQIR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 12:08:17 -0400
Received: from mail-eopbgr750071.outbound.protection.outlook.com ([40.107.75.71]:58945
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1346229AbhDFQIP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 12:08:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=enNfZuJYxGio6EsSgRcVKyOt0Q5RccWfje2+5hlsUBm8z6GsNbLGD+aq7sY/3S4qqLZxLATTRwJCmEO//OdOB60d40DYkNktRLXXLWWbeoZ3St5q9w8ZsnxB7YgQXGb4mzieRmlUGzuXK71ZpYbSG2/DVHoPVolCWv3h4obmpXbD8/eXg/KBa59yc7UERwfZnoWc+I4q9vg/5F51IvlJl2SP7nYhbJ6abiGRzOLnB0Go+viiNL09LAyysCQzg4NxGWuNHNROPDIoNfBhlMQBzKS1WJL+sFBllF3vHVe6UiCqTZ3wIXdxsyUsCy/LRhApMrhAqtx1cC6veGMVKIC34A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wnz6uy8YNHhhmQeXvmGgXqhstDeSwU7avir599GMT08=;
 b=Hv+UqrjeYKk5iCXlWfouub5+6iNEyDD5zAZbOq+e50vJ/YqeM7G1PzTjwo4PgYYw+HO+C+KZ0yfNcZaQ4w7Qw/vXVcaGfALuQ6GCccfh0CWK85F7RhdeDAwbnp7IQ4QL3bHoEYWd8lFje91Rp3Ck/CFvNJLaprDCUqACSpg2XS0jgiQGvvloH3GFyYFyaaNB6VEHzEQEKX3QJIIOhEQPVByc3XzxjO9euwuXtduetIBJt3csDw1NtyqT2YIYEJMPvy0ClbDnsrW610PpSTYtjrypB7vHHVXufccX2haqMx7nxaIPGIH8s/HevujezcTm4DkuGHE6PBSt0Hq+faZAgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wnz6uy8YNHhhmQeXvmGgXqhstDeSwU7avir599GMT08=;
 b=cLyVhBAqDwc8doZZ5VDeDlBxYQazNfKaPZOVKkXJactLWLkhRfMMcVv/0mcIMrdfySVJjGl47z61CZPPWuPLcZbUBDoD6Gx67UWTiy76/ldR/LFlap1Gz0+u3yZeFnxKlGkGXu6iyVfqq+fFhR5RgW2Uz8tCc+zJbP0pCKp6OEIxOUl9bO31O4P14b7TPgLSwmDinsMc3jyefpSs+UZyRlgg/FUbKmM+1Jk64EHXRc6SInKSn9w65jsrBmFw9OroMr9y/FeUtvPUOknaGnCx52bTfvs8h+lqLfMK99gIQMp2dpr/M40Ch1+Q9ZWjtFmJBXSRD77kshgOvnO6uvO+HA==
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4842.namprd12.prod.outlook.com (2603:10b6:5:1fe::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Tue, 6 Apr
 2021 16:08:07 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 16:08:07 +0000
Date:   Tue, 6 Apr 2021 13:08:05 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dong Jia Shi <bjsdjshi@linux.vnet.ibm.com>,
        Neo Jia <cjia@nvidia.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Jike Song <jike.song@intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH 05/18] vfio/mdev: Do not allow a mdev_type to have a NULL
 parent pointer
Message-ID: <20210406160805.GA282464@nvidia.com>
References: <0-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
 <5-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
 <20210323191558.GC17735@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210323191558.GC17735@lst.de>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL1PR13CA0031.namprd13.prod.outlook.com
 (2603:10b6:208:257::6) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0031.namprd13.prod.outlook.com (2603:10b6:208:257::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.9 via Frontend Transport; Tue, 6 Apr 2021 16:08:06 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lToFJ-001BY7-I4; Tue, 06 Apr 2021 13:08:05 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a912dc0a-a945-4218-588d-08d8f9162a53
X-MS-TrafficTypeDiagnostic: DM6PR12MB4842:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4842CD249A796DC050E96A01C2769@DM6PR12MB4842.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KQFSIk5jqqF9HRIuP5MId2ffY0HJkqc4t0HMeDnBsqoumOdANpfwkLA9XKIfUaooAn68kHHukzWEWQQbjxAKBH7NgfmXsckCQ8o/ntUnmq3yalrK22YTQwpCOjbVEsVCstXbHXa8MnI27g0apKWHLTVl8/4ymwEIpHpx9SmaXNqDyow8lhQ/8Yms4ixScLpd3A2cBc5AcqSyVqo1iWqWqwnUFzyUkyTwbXevXKTclBcU566xF52OnWGIoUi/sR0w8BUp5sbFtM0JXRQuayip1lsnT3E1ZMwwMty1ZQpQy95yZrJFqEjjrQIJ0y2j2O0X7/ZO6JG6me8ak2Q79VgJQwFlsNFOyzI+yn45hwHj+1+MIPo2tH0CUVBxdVHwtd2sZekAgUatAPo1CyW2ZgRDceTsRZI+pWsXn6T0XdB1pnO7DdHAoynSYERKD68hzwO6m0SaqcAb4x8Ht5EJuOyIQgo3xkgzlrLs88LHQD4w1cLNshGQnSzTEuY9K+X1iAquV7r+GivBI7ENHK9zx0RGdOOs+eg4qcxsAQQBeFFwrnI0nFEp6ND3zds0VxNl7uiBOZWGbIL3+GaZvT5nyiPg6qoL58Ab1CIIVYlQ/cpl9Z17ffEqvud6pMfej2e0R397TYFzoumS7/OHMs8tqoqEOwSe5rtx5zYhB2k5CMLQzKyvyZrQ31MGSHkp9A50Fs5v
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(376002)(366004)(346002)(136003)(5660300002)(107886003)(66476007)(4326008)(9786002)(316002)(9746002)(8676002)(26005)(66946007)(478600001)(2906002)(8936002)(54906003)(66556008)(33656002)(2616005)(38100700001)(1076003)(6916009)(186003)(426003)(558084003)(86362001)(36756003)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?mc89ROzFoa53iRJLVPMOtmwTEHdbRoF59azjl6k95G59gUZ6v/dAJoXzPXBh?=
 =?us-ascii?Q?+nH6nGjf+CCx+dASq8yD2xdmNA13tWBNN0EDHf1zQ3I2CHxt0QUEywCcGyqE?=
 =?us-ascii?Q?6NJYnl7nUQrTVwsoPQhSBexkrRKEam4duVQyRMrKAM5zZx2rteQHCkJqOPWU?=
 =?us-ascii?Q?mkl2asNrx+d004SipQkYTPnCy709ajIi9QIIfVFueGkj899k3exYwFbsC3IL?=
 =?us-ascii?Q?GWf8ef7DF4yshB8ug9ugH0l74jF8ExmHmdo77wx2MnOLXZEU0Q/pOVUn5XRw?=
 =?us-ascii?Q?9avCntpybxVb5Zuuw8mN8jh0NXF5YKa1THu8CR+cKmUq5kQKY4K1KfMX+XQX?=
 =?us-ascii?Q?NjuA/66ZL1D/li/BFfdRxDby2bOmezNeooyEAg6xy8bbl7GdtCj1Bvdwvb8U?=
 =?us-ascii?Q?c07eCjG70iXFeTeEkoxngVaiB4DvQ6I59l2bIbL4qbQ0Xl1BA12dVtLJ2skb?=
 =?us-ascii?Q?ceIMvfruUECwDwS4NbqyHGAnnOpCOET2iLsg0jDNMk5DPwJ7Ml/m75yvl+Y5?=
 =?us-ascii?Q?91ZgnlAIN5xK5u9s+BfV4rb8IdQHGdYjFkcRygF1Pqwks+iWrv838RtBDyTR?=
 =?us-ascii?Q?ktl7Ypca3t9hLCndQWm9qolPe+CTcdOKs0xlsjKX6TQZgENNDNkmYPCvy+gU?=
 =?us-ascii?Q?ixyLRh2YCr72vGvfOvyLXrdhVIEc0ueoQ8xnMwUi/ahwEHCFo6czKyzYK7vI?=
 =?us-ascii?Q?wx3oCaCCzlrC42/l3yPxIChmoEhN7BRyuhwkqoGLLyxr1ZCbSqLIzCwfwj5e?=
 =?us-ascii?Q?CXSiF6+ZQ1pdxt0OFn/xIaLKarE2LkBtx9fovo5ggITPw9/bwExhJpo5lUzU?=
 =?us-ascii?Q?nDSX/IiAYQO11SA7exH9szAcajTdgsN+/bklXAzLoo0hXHPwqfphJm33bmeP?=
 =?us-ascii?Q?kLrOXXxgI7ueIeJS6czjt4bxDSxnA2AEEof/YyPweY+D53w+lYKxPqa5Np3l?=
 =?us-ascii?Q?7shwwBh+I6O0phWhgP3sRbMnRjHusKE+RzqMzpNt2v7qP9BZ05TKKfxD91W3?=
 =?us-ascii?Q?DjbnERnUV2EQ2jTTJOX9sWhUxWP7iG0OgmB3Aw3nKWMugsw+ArdHs/54zH+E?=
 =?us-ascii?Q?zmdKo0UYeKK/0X08po3AV7gGne2wFBkndCrMA2m6sB+4nIzYiHE32NHL54CJ?=
 =?us-ascii?Q?BCK2cMovZ7al+KYVxjp/5wu9SK4iUMiMbJCQSpePSpYUkBBv3vjruYrbn3ie?=
 =?us-ascii?Q?I/sxaJEdHGCEQHmxcPxsd+I/e2/7SzJUln8/mJgHQRilaKPAeOA5cLZZ2uMT?=
 =?us-ascii?Q?BnMpJNIG9d19sssYTsauYmVJnvZWXt4EQMXOqdYIinA6JtA8D4TsMCsB+Sjl?=
 =?us-ascii?Q?GdW20hTPG92LbpiUjXSyxILZ6CuyesgPVUKEVU12CTCUgQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a912dc0a-a945-4218-588d-08d8f9162a53
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 16:08:06.9695
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RvrEfVHFiU1JQrQPva03cXHqpVwHIWloTlR5kAQUR6SmiZvAZWJJeK2nyxP9pzrL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4842
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 23, 2021 at 08:15:58PM +0100, Christoph Hellwig wrote:
> Looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Shouldn't this be at the beginning of the series, though?

Yes, done

Jason
