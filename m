Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D072D39F6D0
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 14:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232788AbhFHMfX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 08:35:23 -0400
Received: from mail-co1nam11on2043.outbound.protection.outlook.com ([40.107.220.43]:20769
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232777AbhFHMfW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 08:35:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eg/wGKHW3LvuZ8yqZijBZDyTgdLNkIpMgmvVkOAW1u4utvWtP0oTwiS8fX4S9N/BILDUFo6q+gfVLrkGfbQNnP1YV6EzaREulxwXuow73EP2KXChsU62+1N5Db9EZTXk2rfQ2ZiaMl+czz8OTscuXVqSf4QrsmkRn9PPVJ0ldnx4LLgSSs8+y+TAUIfRBY5nm4/wCfUCqJQOVTPm07A7zkQrCe0gPM7T47ybvVIthdvKHtAO9E3HoIg0h2Fhwzi2YMBJgwSvvy4LtGWfFb6mTUHBW+tJKrmNjU8lM15W54sHTGJ+q9MVm5qPfhTQcrzRbYgGzSQBGanwa9EUcfqQpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xEXAa4dqxmbsuwgvJ+KzxqNHX5K9u58K4QaFB1VvbhY=;
 b=DSJWivzNI/d/Uw5eY2CgFDHBz46QoqSR7T6nVx3OTzHwUiUuP/hQ73lZAWS+leIQ9D4sowcrFwVyaOg6oYubJ+9MRSrO/X12B9nuKG3FcCYJOPWB+w0aHfiUi3nSbgxuISg758HsYzAbrepwwaGu1WB1mID74d2TAxTobkkKZQ0FxJxLKJdj3CEhp8Y2LsIsEqJMjIuhn8pMDMnrsJ3mJ0TmZEkGba/XZvjfBi0mKnmRBRxYp6o5WdgD5utLQBxiatfatrMeSEoRh1d4Ft0+bI2IhOmXlFmBNS0eiFJ3yZlGjQXpAkBrDwPuJcryu2EekrnvSOf869TSmG7wK1yH2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xEXAa4dqxmbsuwgvJ+KzxqNHX5K9u58K4QaFB1VvbhY=;
 b=NKcyga8pLdV6VU0nwwtCfuAkdWt+jTbB8xi5wP6oBpVov0qFkhPwiPUyhFZrlSAg5twnh44juBDNtGKMWOAn8o2N0GsMBWj8um/f+T4Rdjs4k9OECVeY4pdkNrVUnEU5HexxiyJ22lK5iDPSe+JyqgGcv4VnhYISL3LQCzcyDB54FJUa1wgDBVu59MMht0XdHxVtQg+QG3KO6hzmzTvqSPgggSyhfOpvvkehjeojQ3jspWIQp76JdJkhOakl56tLWEKeMeXuuDPMv1wC02bdRlVEWUpxOSUI9evP+QP9rBBu1PrM6c8NpWEysblLZJV4qTMIiERANClxNMAkffbM4A==
Authentication-Results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5556.namprd12.prod.outlook.com (2603:10b6:208:1cf::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Tue, 8 Jun
 2021 12:33:29 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4219.021; Tue, 8 Jun 2021
 12:33:29 +0000
Date:   Tue, 8 Jun 2021 09:33:28 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kvm@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH 05/10] driver core: Export device_driver_attach()
Message-ID: <20210608123328.GB1002214@nvidia.com>
References: <0-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
 <5-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
 <YL8L9Vgy1FDGUypL@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YL8L9Vgy1FDGUypL@infradead.org>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL0PR03CA0003.namprd03.prod.outlook.com
 (2603:10b6:208:2d::16) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL0PR03CA0003.namprd03.prod.outlook.com (2603:10b6:208:2d::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Tue, 8 Jun 2021 12:33:28 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lqavA-003pRC-45; Tue, 08 Jun 2021 09:33:28 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5cfddd8d-8ae1-4eb5-3033-08d92a799e7a
X-MS-TrafficTypeDiagnostic: BL0PR12MB5556:
X-Microsoft-Antispam-PRVS: <BL0PR12MB5556317187CF24369EB1957AC2379@BL0PR12MB5556.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3NWYotgO4tX9AsuOdARVYibcR1JHJJQMpeyGbd3JMLdc8+65E6JAOijrBt07uxMo8ZG/g2vAep02Q59gdp0I30HRSe9eNxEmJom0v7m353J36QwrAWknLlRNKvdn7WumgrgvZ7yBOZ5BCeBZYJ9iQf343b0yMeU6N75cHUc6W7QdTIw3LDng0AxpYnDtxIBvu4YqSXFFLdKu5Z/zvx1GzvVXPvuW/4mNqO0zNbuAFeu3wbPdhq6rNOHr9e8NdRdz/pFxfJrMdQW9XEaJlh0XT7euhEl0PqHtxJvJT13p6PX7L0yaZsUsqFG7Ql+fvd+GunCvIcDOA465QcmSQjJxyjuz2KeKnuorNDpK38NaRT930tetaAQleEEHUTYlrZs473aFd42k8FM3hYpR7wRbSbQ9UyzOkv4pgW/CSAMvocvMow1rQJgWS73l0m6NGMqczlsz49zMwzmF9elI0ck6YluxT1rWZezsjNiZR8sPsW8E2t42bvlaCLrygTOJPBCesJ0tPU1oe8OXBWoxqNls541Jz9ilzCfIaGcoeImsW06IaKKRdm21Ofduoiri9tdP+89j30t8eH4N70BNPnjHfwdwY2/cR+4CJf7vA8SOMjs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(346002)(366004)(136003)(39860400002)(426003)(33656002)(316002)(86362001)(54906003)(2616005)(186003)(6916009)(1076003)(26005)(9746002)(478600001)(9786002)(83380400001)(4326008)(2906002)(38100700002)(66476007)(66556008)(5660300002)(36756003)(8936002)(66946007)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JpAamaGdNaNk4KGaUAj/g1jTnzhJkRuy31EmFbrWC+krhvl6K+qzydlvBcIv?=
 =?us-ascii?Q?1boCtt4L41aYzGjsAvCq5TudPCaYnoGFeGSURQSCam0zwji7VSz/r/v5TX7O?=
 =?us-ascii?Q?auCpADQL3GoXsxLz+NIulUq/DmZexOC18GLA0/OjJRhEtdTIOa0zeYL/2cSI?=
 =?us-ascii?Q?LMTt4icjKeTMyfBR6uI6LofdCiqRn4Vt06yLQMV+XYsDHxsldTSLS8HABD1Z?=
 =?us-ascii?Q?H4e4RN9VV/9b15iZKb6CPwgj5hbqeJaI+t0OnMUOvk6ShDwh1GqvYnwcXLEr?=
 =?us-ascii?Q?b/nHoJwOdln07N7UwSAdcg0+SSMqGLUBo78FmHvNtUzP4FNmLyv32dVRWc9P?=
 =?us-ascii?Q?cplVhcnYrsU9aiz+fZ0KWhAneR18jyfvpRQrsLQzxnLjNlPo15q4i0FiZO9a?=
 =?us-ascii?Q?YuqHkvPGhMhDfYCjCAx812TIwKiOIiqs/ylgphbzdJw5LQhK79d752H15DAH?=
 =?us-ascii?Q?Xh1XC8pzy+5xM51uknkw/sW5N9VbvCO5Qec6YW3URnXZIJu1k6ZgJV6CnrFC?=
 =?us-ascii?Q?2w2SWeIQmRIHltPJxeSPyJCnisQtujWoU2rYQNm7h5gjZJA6YBQzpFL1XxIc?=
 =?us-ascii?Q?gJDClzQdCyb1Zj9hRcQYOC01bnqLnqLYMqnDBvx5hplGuu+9RjuO3cl/3xIk?=
 =?us-ascii?Q?pC8lrPkrAwUktJCbLp7yAiAy8LW/EUEbX1MxUxf17A2WbKATVE75sMeCoLMB?=
 =?us-ascii?Q?oFiJTnx4vw7cq60KKqcSjIOtJxegxbWucYD9d+IVFnDMC8ETM8w45ZU+hJR4?=
 =?us-ascii?Q?ZswZi0s6CfXJqB86y3K8OWj74JrIBxVudnd3pSpElvYb/9xKvo83Q6/1CgCB?=
 =?us-ascii?Q?Cz2rAa5eJ2GDl9OT30aKemFaT5nrg/oJMiBDnC95JPAF+G1EbuopmLPSKXty?=
 =?us-ascii?Q?NjUvwDNpi8IHRPKRLwPXzWyy/GiWM0ZHXKuKphxVGRJygg/Fv0UKrrAGI3tE?=
 =?us-ascii?Q?F+5XnGwPoiSri0BabUC6NNvE2cX4EPNElCQzMipwCNp17k/lU3zaykkOmeKr?=
 =?us-ascii?Q?5kqBgXPgPNSxxtGzKjTiAUz+bFwfZRbJKfH0hUpz4AuJudaO8GrSE34RQNPt?=
 =?us-ascii?Q?JazZxA0IjdZu5VM7asC7Lk0SGAamy5rrW8OrS+q/Phovo54yi73/ibZ5zRnB?=
 =?us-ascii?Q?d5WTqqW6LF9vsXonDTDCYWI7+h+lKl4vEL3bkSz5jzATJrkD4UBj/evk4c2W?=
 =?us-ascii?Q?WmwyITftegYWiaOfli2rM2HxEH65uX2JlzrwS8ZRjzrgsm+minq4d64hvvRT?=
 =?us-ascii?Q?K7sWqNV79ADqX4V9PUZE+PfAgCaSFWHXTWPEAuoZ1YfuWWpwCfeUuif/oqfN?=
 =?us-ascii?Q?bhABpDM5v/LG8XNyGmJlZcjB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cfddd8d-8ae1-4eb5-3033-08d92a799e7a
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 12:33:28.8789
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KDkDP6KwS9sEm4tDP8TQRuFUsfK3q51+Ms8pbSjBcgcIC8dl53RfTKNevVN0EkT7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5556
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 08, 2021 at 07:19:33AM +0100, Christoph Hellwig wrote:
> On Mon, Jun 07, 2021 at 09:55:47PM -0300, Jason Gunthorpe wrote:
> > This is intended as a replacement API for device_bind_driver(). It has at
> > least the following benefits:
> > 
> > - Internal locking. Few of the users of device_bind_driver() follow the
> >   locking rules
> > 
> > - Calls device driver probe() internally. Notably this means that devm
> >   support for probe works correctly as probe() error will call
> >   devres_release_all()
> > 
> > - struct device_driver -> dev_groups is supported
> > 
> > - Simplified calling convention, no need to manually call probe().
> 
> Btw, it would be nice to convert at least one existing user of
> device_bind_driver to show this.  Also maybe Cc all maintainers of
> subsystems using device_bind_driver so that they get a headsup and
> maybe quickly move over?

Sure. I would do the MDIO phy, though I cann't test that code, I'm at
least familiar with it..

> > @@ -1077,6 +1079,7 @@ int device_driver_attach(struct device_driver *drv, struct device *dev)
> >  		return -EAGAIN;
> >  	return ret;
> >  }
> > +EXPORT_SYMBOL_GPL(device_driver_attach);
> 
> Ok, this means my earlier suggestions of a locked driver_probe_device
> helper needs a different name as we really don't want to expose flags
> and always return -EAGAIN here.  So maybe rename driver_probe_device
> to __driver_probe_device, have a driver_probe_device around it that
> does the locking and keep device_driver_attach for the newly exported
> API.

I put the squashing to -EAGAIN here specifically because of this
export. EPROBE_DEFER should not be returned to userspace and if I leak
it out to drivers at this point then one of them will eventually do
it wrong, as we saw already in sysfs bind_store

Jason
