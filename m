Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8A440CC55
	for <lists+kvm@lfdr.de>; Wed, 15 Sep 2021 20:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbhIOSI6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Sep 2021 14:08:58 -0400
Received: from mail-bn7nam10on2066.outbound.protection.outlook.com ([40.107.92.66]:61856
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229479AbhIOSI5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Sep 2021 14:08:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V+aqycwZX7p8d96RFCl+hooZ3m6fhQaLf5KD6YUgH0pNA+Y9qWuYateJtVtXufg/kugDb/TTqop41+6U5UxOqAznHf6btAM/CdFAyrUYu9Cze6751sHc+5Vci3jDI+swXgqmbwdtPmB2fnVa4WtFiqAruvoWsfLhw8wYYecQQj4/OG5LaXcGlmSmQM+EZc/PXBRiqkQ7MGgpZflWyt+Ejvo3PLxILiinz5WM9Hh1AZ6YYpYi08farXKUkjZ8B62gIU27Z1nbs8WyH9bz/+rSJkZBFEiMpI/57wNptWWc6NqQs6T/cDvHjQJT9m/9XI/PhxbW2WmuxIB+ns8Y/IeQYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=qEnZpNlikAUSbZ8oWPJ0ChSx+P6MaSpJYuIXWMt4hE8=;
 b=URAEpyk3x0OIFJNlLKsg+TOcRdXIfvOnMFGg4Ci7BkzRTOf00mN3UO0k587CfmeRduT69DOG4bWfHL1ouFf8tqesumkCXEpV8aev0tug+xU6JbqWIYEZIoF6vhLIP49ATe/tEmzW8VTOlrdnSqKMx1PdoPwncpf6f3Nvudq18ZdEJF6tXIPp3OTprDcZgb9brQE09Xe8b5rwtN1FC4xIiihe4kiUW45kDKWp5POdFsU7Ob8R4b0XJXz9ARNntPIg/TaZfe3dfjwTQA/VZgdsOooH2t9fyEm70BSaKa4COU7KbKTrhrv6g/H3HKT2v+3jhgf32x0RSgKpqWbsoEGnng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qEnZpNlikAUSbZ8oWPJ0ChSx+P6MaSpJYuIXWMt4hE8=;
 b=ijqD7TPzXd+Y/PAdGHRHk5N6r9d8yE7XXeja5iHzQqTABl688aQgX781tL6+ccydh2AVWiKvaOA36Yi+ZY4cbFQe9YI0vQN1Ki4DSzlZNnwxAl4rfqY8FRESQhX/n1zV7AVHQpGdYIWgessE+OFiEBhnm6k2b/fQWWIUdz4yn9A0ddZB31ql2hZVdmy1JdgBM6vgpOruvX9d6CaShFpGv2QXv16XBht4FFHLpHGcphSfYDH2vBWddBpcY2gp3x1NeM+7eujuOCsXOSsp3DphaslEVPbP+I9wn/5OdSpMTFIuHTwaUMw0OTvBop3EGsFc2Ar+TiceyQtISSjqY2EZeQ==
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5272.namprd12.prod.outlook.com (2603:10b6:208:319::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Wed, 15 Sep
 2021 18:07:37 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4523.014; Wed, 15 Sep 2021
 18:07:37 +0000
Date:   Wed, 15 Sep 2021 15:07:34 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Terrence Xu <terrence.xu@intel.com>, kvm@vger.kernel.org
Subject: Re: cleanup vfio iommu_group creation v5
Message-ID: <20210915180734.GA256807@nvidia.com>
References: <20210913071606.2966-1-hch@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210913071606.2966-1-hch@lst.de>
X-ClientProxiedBy: YTXPR0101CA0004.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b00::17) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (206.223.160.26) by YTXPR0101CA0004.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Wed, 15 Sep 2021 18:07:36 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mQZJm-0014sd-FD; Wed, 15 Sep 2021 15:07:34 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 13f45edc-87bb-405a-e601-08d97873b2ac
X-MS-TrafficTypeDiagnostic: BL1PR12MB5272:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5272C09DD2F934249527B980C2DB9@BL1PR12MB5272.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +GiyMBcRbsRK1Mpjmtvir2JskCTIaeY58QUeThw3FFs6PTiomwi9qtV/8gOqNoMe/G6oCh/l9WNh7uDxezU4ZmMoVJ9yzKk0Pn21+d8WO/WmUk+A22fabvgJnTptA6i15+idTAbf4x5q1XizGoBj3sWd3PduVnkReK/gEoQ87oCw3q0cqkqnvNu3MebMOhDFfHrwGOMFJaboewdzWf/RMXXvcbfRCS/KRsJj/91avfjLKTFF48wUpOhh8OUt2w9NXtS9y0DSE7Ps7480OpXFnidHjfHthEOa3JqorI2FgY2ip8nVZ0HhRkYrHaajEPTHHaW6WRW7b32AbD6dZs9gzYNcSi3t92YsjNomYUD4YZ7gE8EVl7j6Y9AUgFEeU8fooZLmwHxduLEsT9fv5jUzm8Divq22aTeNVgeAjGlEBqRamod1Uulkb16dXVW91uvfY7ZbxEHDGsg4rmiOdX5fCz1Ggubdoj6Olk/8xP12yW8uF9+T7950ULH2RZy8sZmEfbrwVGB3ZOzHu8OxTUOMOUH1PpptMUFS13qFKONhOc22ARR6+bvy+TUgY/qACN5aMYDc4xkjohpnSihMMV7j6WNgf0V+gsMqjeEEeh8znSuUfnJ20EbVkgJZth3QP4CgZHkfwFbV3m6cZWm2Yleyh8WuANpmhZmVfe8bqVI6wyAv7ec7BpDM/pwuI+g6a5rv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(2906002)(508600001)(1076003)(26005)(54906003)(9786002)(9746002)(66556008)(83380400001)(66476007)(66946007)(4326008)(36756003)(86362001)(6916009)(38100700002)(8936002)(2616005)(426003)(316002)(33656002)(8676002)(5660300002)(4744005)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5w4cYrGQEsOIkgoBiSU+ryMfXDmkiHggOQuN43gqDIiYOwgPQQj4KOx0PMAN?=
 =?us-ascii?Q?eqChv66+VffnOhdjTOo6ENhKZlkLtN+/LfuxHx1o8/xExFBoKsszA/bEQv/8?=
 =?us-ascii?Q?o8Px51DwrQm4iOD/OHAYB+cOUJTzBzaSU9Cxymfux5koVqluBLeCH8J56HAs?=
 =?us-ascii?Q?Cpqzk72e827QXLb6u57BJyg2iIMZe/QQZmncnbjS5HFR4Bt2hStn2EuAYfRD?=
 =?us-ascii?Q?fSJYc+OGq2WapbjuxJi0D8qvrYytVzNS+zcX2GdCnxK3fb71OP5MM2v25BCh?=
 =?us-ascii?Q?RxbtfnLrT7soA1XMEkMY0c+Qpu+O+TgTYCj9qB4gRgDf9/VaOW6zSqVRQgwx?=
 =?us-ascii?Q?ZfGA8a6eRf+nFrbcf5j7HwbQKM697rSWIPWbUAcC3hZU6X9bDPslJ0j6+B0A?=
 =?us-ascii?Q?8oesafWN0ZDWp1UokQoZD+ZbwXV7f3Xz/ubfncIj/8IBWdT8gdpJVUt3uNZy?=
 =?us-ascii?Q?KvKLcgJBn+A3wsQlqH0RPMvsMlWSZVHsM4K3xG1WP49a8wHUC8+fvIW6BbeG?=
 =?us-ascii?Q?TiFthpXIfsLF4YvcaYw+vZnka1opeEskOIcDgsNhZ69mABcgRmeQjByVgXWM?=
 =?us-ascii?Q?Vng3g5u+dgkuibCbWhgfI3NMUlNXDHYSPMqHZY2H9maFpQYT1StgyhBKyXRL?=
 =?us-ascii?Q?67CCq99hsFyy6PgocIy6BTAzxXwwQyHLTVAR6IayIsIPodyd/7vEKkkWGo5j?=
 =?us-ascii?Q?zZXzMbPVa+xlrk+npbS3g+uuwuMjQu/avyVdfmL8hehshX7F++9N6w6UW41B?=
 =?us-ascii?Q?Nnv1nma7WTAehKxby83BDa5yNTy6SP1mu+esm0PaD/zmp+PFeWI4yPWWGLy9?=
 =?us-ascii?Q?fJdBZOVqdWdFaDjc/VVv4fA+dbGjTcDevjgFZ0rADGduC9YvgVkzwhWWmgbL?=
 =?us-ascii?Q?xDPS7xgnDBV0WcQgxVbPAUCfZ0sqzeQffmLP8buPNudM9e4kB/uUwMr87Emi?=
 =?us-ascii?Q?L0jxY50cBtiDibLjkLQd4jIZ4F7lErJXTUinQ/T7CHb9htpN+hP//cdrk9wP?=
 =?us-ascii?Q?MCd5l1OzkE8tTYJdYrfBPufS9vhrz1H9BqEGnA1pvkQpEr2lpNA9xi7LO39z?=
 =?us-ascii?Q?r+ns0VuVrmNqdUhAXBKvzUEVv3Sf6d/Wz3Sp6h/+41tvxFo85nNumtML9Jcr?=
 =?us-ascii?Q?EyT30xVQVbzNiN59TJvkngzd4CHmA6lhDXwB33mRV9p6pAJS6Gz2w6GxtjsN?=
 =?us-ascii?Q?sQMIoCf9iCsrz4W4d2cgHGQQGgw7vbBFPnMy9c283hd3zkVEhmPTrLc/fzKN?=
 =?us-ascii?Q?F/CT/FnHa3bpXgitW5bs3dXV4wYt6zACQIfSGz4ZpOYZsY95I/7pBvv3IKqc?=
 =?us-ascii?Q?B3G5fhHGkdGXDzSNs+gvqOo9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13f45edc-87bb-405a-e601-08d97873b2ac
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2021 18:07:36.8891
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TjRyowpwFM1aKhxX5KfM+DJdN30wcdOr2ZqStvqvDXV1+xctTP7TkOR3LXIgeRND
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5272
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 13, 2021 at 09:15:52AM +0200, Christoph Hellwig wrote:
> Hi Alex,
> 
> this series cleans up how iommu group are created in VFIO as well as
> various other lose ends around that.
> 
> Terrence: I did not pick up your Tested-by as there were quite a few
> changes and a major rebase.
> 
> Changes since v4:
>  - clean up an intermediate version of vfio_group_find_or_alloc to avoid
>    reviewer confusion
>  - replace an incorrect NULL check with IS_ERR
>  - rebased ontop of the vfio_ap_ops changes in Linux 5.15-rc
>  - improve a commit message

This all still looks good to me, can we get it into your tree in the
early party of the rc cycle Alex? Due to the
vfio_register_emulated_iommu_dev() it conflicts with the vfio_ccw and
i915 mdev conversions patches - this should go first..

Thanks,
Jason
