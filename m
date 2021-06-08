Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 044C439F668
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 14:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232452AbhFHMXz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 08:23:55 -0400
Received: from mail-dm6nam10on2084.outbound.protection.outlook.com ([40.107.93.84]:46781
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232498AbhFHMXy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 08:23:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JRKl/+TO3NDtxMPAu2xLpjyLBJFIgKMbN9fm2KpAVGTCV7Rt0QP0ReCvRnqTQtuHP9zFQu+ZsMYkgGlj0hHoOcwfNaQ5Hk/dHutPIBS/b5iy29fiJmtzyrA/eKo6Q7iPLLpF1GcGTIWIRty7HlFftP1HMtMjRhxTuzPj5ZsY+xNcdy5gO4btwGdXfVT/lgM4pjz4dsrP2k9fYDDLcTSdMgpXVfkCw3smlHxh5rENQ59GMrykq8PspTxNe10vawATdQKDtiFcGnJMTbOqbNaUuMBDvxbvLSMtycEY7iggs3R96PaczM/AYI+BaCDXkZ0/SZ1IvJvJlf2wKXCcYVlIbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0wB7QcmZPTnDvKr1UbsHbvnLDbGCEWe7JlalQvN8anQ=;
 b=nRXW/oXQlsPXmJGN//xjiQr0kTzVQdpoJvD2OWgcC8YghITSwEeDhJQB9Unq2kyawFLTPv6qjnY1yS6MEuNEEXPk136x1gGQHiJ3JFjlqq1TeIJUi+2dxuBgscMTMVVQJ0jJPUwrXyx+dprnrc70G4Q3xtgJRB3vcubA55KWfeFEpz3UX2YodqeUZVit52EIsYDU7fyHSANz4wYHeMu7CeUIAdEL4kfBTbDB8vFIwoNpmRsYfy0kvDZ7Si2fmCGtTEW2R9cRYisVN/iiH7h5cRzKgMAsDfU+QSVxYELwmYE7vdGC6dORLsN8HZfm5uI0zhQCnm015ofbfwJI1LqZ4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0wB7QcmZPTnDvKr1UbsHbvnLDbGCEWe7JlalQvN8anQ=;
 b=le9zy5j0uMlME23Cs0jE+UgNxWLnU61HH2nBUWVOfiKU/NWCvN33wKB31iULPb7WPlmKlgK4TgVCtzDMpOJ38pCLRyhZehwW+wNpvGCMdnGYebnNlYU/9T3BcgdIVofsjEcD9iDkDzEfvLDyCZbRiimFCW1Tc5yprUWzY4Oz6osaNdbkg0wMqUYcpYTCZmB9EiF971gAyl1jJhJriBfm+BSu28G1rsfVQPtBDRl8qyAL6djVJiWL37Qnx1d8MnC7SIDn2pkVpg9PGrOZXi8yufZuji8ltT8z+qOcx0/CmOmtjLe73QvlsYGpAbU27NsVngVfbnbfsVHHotD8vcdPzw==
Authentication-Results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5286.namprd12.prod.outlook.com (2603:10b6:208:31d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20; Tue, 8 Jun
 2021 12:22:00 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4219.021; Tue, 8 Jun 2021
 12:22:00 +0000
Date:   Tue, 8 Jun 2021 09:21:58 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kvm@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH 02/10] driver core: Pull required checks into
 driver_probe_device()
Message-ID: <20210608122158.GZ1002214@nvidia.com>
References: <0-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
 <2-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
 <YL8HLhJNFgIGfEQm@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YL8HLhJNFgIGfEQm@infradead.org>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL1PR13CA0369.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::14) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL1PR13CA0369.namprd13.prod.outlook.com (2603:10b6:208:2c0::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.10 via Frontend Transport; Tue, 8 Jun 2021 12:22:00 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lqak2-003pGU-Vi; Tue, 08 Jun 2021 09:21:58 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1011475a-c670-42fb-5f7d-08d92a7803f0
X-MS-TrafficTypeDiagnostic: BL1PR12MB5286:
X-Microsoft-Antispam-PRVS: <BL1PR12MB52864EB07D4356DA8D54B855C2379@BL1PR12MB5286.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ps/wh5nQb0dyD/2c4RoruYuPiBCE44iIaQgrDZrKRKk6UFbpGON/B+knVSFE3UjqEp0HAZ2K6wK+MK6+j1yt5UwAWh+NXUIspflxYBycYlLZsEWLp42Wd9xeo7ORoF1yIQLaQrjut6/9vCCz5+yPSJ3oy8uOYZketA/7LSD5E0FHHOdiJh7agAkegnr5ucEZNiYIt3CWV9UmjCuEvWo5QyDYYVLjlZa1R4RtZXie8F1s5UwSswhHzxHL/rD4c5jp7UWrbyqCvGmP1vZtHUHMu6LkDXq/SEokxtxo8nKkSpE29sqWL+HUuOtLO6Flffjt5CufvvMMAOxdUtfRopdvd+02gqoHjEox/ulI9lYItgCRRl9vYKso7mp1jZJ5nbQOaLYz+A0DVRXZgNzpQPZvLzuDsXxuqnzfdE6ftOwHEl2lK8cdli+1QwX2/5S25voB6uhX8YaFe+T2IBfYXnVjHd2Wk0rD/Dpu/a5ya0yEjRHUvIClJutmJTve5hMloINu/gs9k9sbTe44VInlu7kPFZIn3WHEjRUAMHhUi34Cq109UlvqMnBCyHTwNFrPSNKOzJz8g11ZVY6aEquC6tbEg/+UFsj41zBiuJvbFFkE3PM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(396003)(39860400002)(376002)(346002)(8676002)(33656002)(26005)(9746002)(66556008)(54906003)(186003)(5660300002)(36756003)(6916009)(426003)(38100700002)(2616005)(478600001)(4326008)(83380400001)(1076003)(8936002)(66476007)(86362001)(2906002)(66946007)(9786002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tGF84BTJKLqIWWC/opMJXi5puy9KUBSS3W56YV+uhUAN0ET1ilVAl/k5nP0Y?=
 =?us-ascii?Q?NdzFQu1FddHvSXz4uQ3pmXJcv2iqRiFnvxnmToFKZjtsRi3NewAVBJszNRe8?=
 =?us-ascii?Q?LobNlt93sLegX9G1dx4HbkbrLMrkFFxcdtBQaWJ2R8lNF04dw5jjVVWYc2OT?=
 =?us-ascii?Q?zfuBPW7sICW+fg2vMOey0RbNf3CUKs4tK8XIDkRl9XaGmZoltFU4lXnBtE2m?=
 =?us-ascii?Q?xUpXi0aI4l2QcKXFX2kfSHV5kyiqldNeVegelRU4Tr/Ow8eW2B1NfmntIdjh?=
 =?us-ascii?Q?KrdXIyKxYzB0agn4JdUN2HeGm5R+uLlA1Ul6HFQ5gbNsuF9XwnE3NUHLr0Mh?=
 =?us-ascii?Q?Xn/G2bDnFRtEMc+9LaO0NesLDjnCcXqiPS/VFEqCoFEmaPTRWQgaGZzYzIuH?=
 =?us-ascii?Q?2dkGvChe19Iv2D7E9D+ytiOEr8gjxZEwNJS/D9JZ/UskQ1GvFyS56k7N0ME7?=
 =?us-ascii?Q?gLq+ZJJd00jrzxJ5UIHORWy8ny7CbrA77oJ5JEpTbdxceZGzGks/rBZz1FmF?=
 =?us-ascii?Q?62aVgWNzR1ZMTXd07LhdRKMkFxq7P9TA7rswXAneCQNkLu2N1j+EfYO11T3+?=
 =?us-ascii?Q?U2O0sJpMNGPR96V4eika2vptE3Y0lB+t5r4pOZ5HmrR6VlUREt7Dyx6hD4Vt?=
 =?us-ascii?Q?QAQpeTnBT2xGo18xSGHdxBL3vqiCqMnZfUAmoHaTyuGUdOobhTAzPFX8tvGU?=
 =?us-ascii?Q?Je/QIp1+BFdHNfRSElGBMvqAMLo45qfO2ko/7JBsYHwcESlyJcOHo4jhu35g?=
 =?us-ascii?Q?eN26RdIZj5lsefKM/ON/GCG4PR0v/8k6x/J4oiRE+QWQktFCFBV9f4mqrSIl?=
 =?us-ascii?Q?hkYfjKZKIQGk+EjYDnj3Y+ZphGx6tFaQNIS48VGux/J5vLD4wkhU8f6/Wgdu?=
 =?us-ascii?Q?U11PWzjOYDopQatXQ3f0v7eC8kHq/9D5zdL3mMu/qtSYFB1GiRKO2sa+Yto6?=
 =?us-ascii?Q?tSv4XrBolYejT3V91/Wf6MDspC+DHVBZzmOEsIEo3le8PKB2TEgSbjXk6UcV?=
 =?us-ascii?Q?g2AvvFsB4vlGtr8Khb0ltXimbZEVgH+UN7T/lbRdcHDyNJm5duLjbBj2cUfT?=
 =?us-ascii?Q?D+dMjk8yNvau6MRtmJat4T3WzNQ+qxcu0tr3frvx4NNgK9BK9gSV1LVg/EWv?=
 =?us-ascii?Q?Gdm3pIN88SC1J0DKmwC1qHR/3QnJP0FeG20GEZ6sXtY6x0xnOsSeGsuv0vZK?=
 =?us-ascii?Q?Rg1kqTrrNhe5HGRPZgD5XZ2Rs/EI/kG3jTOvRVQVHZA8i7Sz2BsrW/ipVZtx?=
 =?us-ascii?Q?i+zFjCbAuelA2xQUh3kOKLTGNA5w6itqbhCjr+KydpbVwwOwoXm2CMHb4zYJ?=
 =?us-ascii?Q?wojMfjvlS5YpoMfI6t4sduMK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1011475a-c670-42fb-5f7d-08d92a7803f0
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 12:22:00.1218
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gn9esFO5HmLUnJTlZWxBjWyMLWjgtmKdN0rd5Smd3rfG4wvNIf5A9Phnx69AULGT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5286
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 08, 2021 at 06:59:10AM +0100, Christoph Hellwig wrote:
> This looks good as-is, but a suggestions for incremental improvements
> below:
> 
> > @@ -1032,10 +1035,10 @@ int device_driver_attach(struct device_driver *drv, struct device *dev)
> >  	__device_driver_lock(dev, dev->parent);
> >  
> >  	/*
> > -	 * If device has been removed or someone has already successfully
> > -	 * bound a driver before us just skip the driver probe call.
> > +	 * If device someone has already successfully bound a driver before us
> > +	 * just skip the driver probe call.
> >  	 */
> > -	if (!dev->p->dead && !dev->driver)
> > +	if (!dev->driver)
> >  		ret = driver_probe_device(drv, dev);
> >  
> >  	__device_driver_unlock(dev, dev->parent);
> 
> It is kinda silly to keep the ->driver check here given that one caller
> completely ignores the return value, and the other turns a 0 return into
> -ENODEV anyway. 

Later patches revise this though, I think you noticed it

> So I think this check can go away, turning device_driver_attach into
> a trivial wrapper for driver_probe_device that adds locking, which
> might be useful to reflect in the naming.

I was scared to change this because "0 on already bound" is uAPI in
sysfs at this point.

And what you noticed in bind_store:

       dev = bus_find_device_by_name(bus, NULL, buf);
       if (dev && dev->driver == NULL && driver_match_device(drv, dev)) {
               err = device_driver_attach(drv, dev);

Seems troublesome as the driver_lock isn't held for that dev->driver
read.

So I'm inclined to delete the above, keep the check in
device_driver_attach and not change the uAPI?

Or the APIs need to be more complicated to support locked and unlocked
callers/etc

Jason
