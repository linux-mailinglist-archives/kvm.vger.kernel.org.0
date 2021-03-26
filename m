Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1555B34A6E5
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 13:11:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbhCZMLH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 08:11:07 -0400
Received: from mail-mw2nam12on2083.outbound.protection.outlook.com ([40.107.244.83]:51488
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229871AbhCZMKw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Mar 2021 08:10:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R8q7Pm/Uohyb7McK1OSdeOXVAi4G4ErKI1yBnpvhYRXGjJT++WAgZQnKxWAH+AQgmcYaqpuTgjXUahkeEcS6cQD9p/sojrvez/c1/c1d0Bl1exc4JGh6aTanQUO5ocmu+/IeqFDPZXUTztNu/xhTPyYBT4iRxgp/kXEuAVElnZ2rC0AflwOyjzugKH4yXNFCbZyOPFUHkYZ31P7U7vOFCoid8Lx3zI4UMDbzkHJhgujgoMunQOquw/TVX3HZ1vipuTDDfpTzd7EGXBENe4ATkdPMxOjWDb7mpmuI64ZiP1rId1F5K0MXC84oegRWkOsxC/Mf84H+kwCGCZtVHN2pLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cW8B1qH1hbn4OPkLE8prMld4tBCcUDAeU8bAEkvdtXY=;
 b=nvgih0l8/iz762RahxL1MJ4zz5UtRtFTZF8rPS+LP31Sy2Wbsabra0ptC6MFcIgJh2ahj7kGecH+Kwf7wMqj9QkPKIIhDASR0FM8uPkBhbAE5TBtVaGAlpxJ+AaSPmyr79l8MZ5opAtiId0VNrBhnpVpF2WWv1rBGraFJU53KV+Dfiji9l1mVcEFHJGnT0xklCRdzuJCGt0FscMonooj6fpfGZ11EiHspIHopkFeQXW2ZbdIS7Y+31cfjaquSXmZidJgP3+cIuYBHDyEEa4Fl+k7LYxOrcHji3f8jvmidmeZk3YhyGj0CrJGfsE7iFIpH5owC3dR4PW35ydyWhd4+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cW8B1qH1hbn4OPkLE8prMld4tBCcUDAeU8bAEkvdtXY=;
 b=Rh//KerENE85bxd01x15YbnjXFnbkvYc5mQ1NEvRB4yiAJHzI32yZzDBRji09O7Pyq1rn3mFThQ48+Mf15HlfVnCg5yQiXX7eIsmRQC/Ng5IMtTMVTWYogN8JPfuoJNuFnjNbexr3Qy63mFzROgh8MwvonDnngWdFBCiMpJpSnNTSfLKBPkQK34C3dptP73EKRD/6uV05B1VKs/SiGTNKXahJPyipAmDk/8sEd/1bD9npNkQiaNRcB9S7DBtj5ndasaRMR75/QLDSZVfRkngWFvfqLwXxeSbpxxV9utMepENR7mLo9jjLXW6Nx4mu1K7bWl3QInISb0XUoSVZDdEbw==
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR1201MB2488.namprd12.prod.outlook.com (2603:10b6:3:e1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Fri, 26 Mar
 2021 12:10:50 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3977.029; Fri, 26 Mar 2021
 12:10:50 +0000
Date:   Fri, 26 Mar 2021 09:10:48 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org, "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH 03/18] vfio/mdev: Simplify driver registration
Message-ID: <20210326121048.GN2356281@nvidia.com>
References: <0-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
 <3-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
 <20210323191415.GA17735@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210323191415.GA17735@lst.de>
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: CH0PR03CA0167.namprd03.prod.outlook.com
 (2603:10b6:610:ce::22) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by CH0PR03CA0167.namprd03.prod.outlook.com (2603:10b6:610:ce::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Fri, 26 Mar 2021 12:10:50 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lPlIe-003Kdt-Mu; Fri, 26 Mar 2021 09:10:48 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b43e4ef4-e290-4e58-13d0-08d8f0503213
X-MS-TrafficTypeDiagnostic: DM5PR1201MB2488:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1201MB24881D3D51B5C6D2345F09D2C2619@DM5PR1201MB2488.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XhbY5S+sCghHcOvcZEf/6vWaKs6bxMhgR9/W3CPFLM5Lvg0/CkNS4B+Nw9tnmGrC3wcKEruOhFJSUu9zYIx7tJzBdRdWjbtCfo2db2TecxefVPAqesNq94Sax/73qPWNs7VcoScC99tpDJXuDPuq//Ss03VMpPCG4m2iP8m+MJfcHZAIkpGtbABdmIBkLPTvOS9/K71utJH+FyIdOiXmTfQRB083I9CFX9CgcphrHWfkfFYhsR4xNO6j+PpNRGk3DDudUhHzPqO7WnGCK4tUBoitHit18KKXZ4+W83tK8ikF5C2fGC96pl/wNHbcEPkVzz9k2kUIxG6Gu/SQoqwCUqV1tGNMSaypy/Nqxt9lTU2z+ZGPIZc701wvYqQiCtKr3hXWWnYmdKJIGc8/PpyqbAl01MSxtOLSZOV2WwU2XoBu+HmIPVvsPL1AEDmZIshB5VKpGfGy0RAoR8xUEEI7w/LiQp7JlNkQpcpFCUeXutp8DQgHx7uGCtN0siY8+/Evw+uQYGzESeVmUoFMbcsSz97z0XklW2vCpylj1Aon7cB1vhP8g3wC7JnSz6vUGLUhjJ6+povuH5mmVLEIk0ioNBQKhKrtBXfZ6emF5BpVlhBer/2H1YziaSRyXsMCvXSG4MTU7jKHM+P7CP/tkxkklbyiheIXy7DT0rXR6HAk6Lo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(39860400002)(376002)(366004)(346002)(66946007)(9746002)(2906002)(66476007)(86362001)(9786002)(426003)(66556008)(2616005)(478600001)(316002)(8936002)(107886003)(8676002)(6916009)(26005)(5660300002)(54906003)(38100700001)(186003)(33656002)(1076003)(36756003)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?JWIQuqwfJc0MCCXSTl60gBPbEm3Mx+Jx3cxt1FP4AmDw+qFK/kSwE8TJh9Rx?=
 =?us-ascii?Q?5nGJ1qT+P1YGHLubvXwGxirYGSp4XbNDJ2AwNt8K9DF0LiSfJLhcAjuF7aEX?=
 =?us-ascii?Q?jkIVCj4LVJ6v64vyGp+mgPN87yPDmqsubgcbN6o0I3F/QNs6oBYJzM/OGP/C?=
 =?us-ascii?Q?8M8OE7684DiC9BIS9DR1tC9l58GL44iC72FINgPubbjSkUFqJg1Ive4XSm3B?=
 =?us-ascii?Q?E289upMc8cg573jJH1ss7edqqEiWsvTCLua26KbuFxCaLY3szfuI0GjT/3j7?=
 =?us-ascii?Q?v/s5GDRlmSe55KIgqoudotnwp35dwIDASMF4Hl4Xx+2iVU6X3qHx++DlAZ+8?=
 =?us-ascii?Q?6CW7e4cjUUBPnH+hxC6czrbfGraBWK776INUiqyBsiW6s9zx/xMD841RBKX/?=
 =?us-ascii?Q?SmxGkN6m3mcvrE+MJ1EiB+6ur4OyoRjoL02QWrl5jvr7QMflcXplBDYJl2QU?=
 =?us-ascii?Q?FdkoKXymsDssQjYbiQ23yGiIVaDyLedFl3p3WO0+TuvBlJwy8L92jQAH0CXs?=
 =?us-ascii?Q?YAYBd5UvBEvEPEIL/cwbwhbF2af0cxFXjV8CIQmtVezq7sL5+BEh4kBDFFuV?=
 =?us-ascii?Q?iImvC39Rnjg7DY+CKfhTFM0xQABKWWwXP6E1R2m4M2WryPTxh9s2NQkKw+Yh?=
 =?us-ascii?Q?znDjmXX9n0Aqw3JIkoyzQVo/eKn8dhemvlXFdPlNCm3FISyGZ5GjRbIro1qz?=
 =?us-ascii?Q?3SEGr87o2QVa50SknrUNFpq3D+oF8GQw12MxE88GT1NGtcuQ1lJWq5X/50CX?=
 =?us-ascii?Q?Qo5HVrDYb5mKa7HPVmt7e0mD7Pg5D2Zfn1eWKNMqxxzvorUNHpWvROJ2SuhN?=
 =?us-ascii?Q?dc5LQ5nDx26f5buyjQaENvByAhpc8e4QaCyKos1KHP0ToLAHh4ft57/z0WoT?=
 =?us-ascii?Q?O/cRkEe0TBrtiUfpf+SsghSnT/MMWh9AyTgXqrxNexylyNAnzbUP2xlyr6Al?=
 =?us-ascii?Q?gNmr9T0GGKlMFpbpEsJsw+dkNDAQWAFYVcsgI0wn4/1ur0IQOn4Q8iUslTT2?=
 =?us-ascii?Q?3Ey7Ngdrvca3uOHzBrxBFd55IAUj8eUbi1RuxLF5aImTbWDLri8tpXmRSzgI?=
 =?us-ascii?Q?Z+uYBO9SmHiEk+x/wn44hX+/Aa7YamawEtNBOTphpWZmJPquHUjLeOi6umBV?=
 =?us-ascii?Q?c6QZTGlqoyLU5hfTGJX4TvGDNrGsW6+bYP/e894gOxBdoQn/irXVRpYCi/Cc?=
 =?us-ascii?Q?/i0m2LWnMXRE2eKk1OKw2gT44BnnBbMRZh7yEACbpwxZDU/fg3gwiUuLgZMQ?=
 =?us-ascii?Q?bcd9DypCAECcK+OnCCXWh5LA3taGcARz2SrhJaPP+CG7KHd0E6X3onHS2pHL?=
 =?us-ascii?Q?jY/t6wyE7c5LOAbFwx1mQEo2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b43e4ef4-e290-4e58-13d0-08d8f0503213
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 12:10:50.3085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R0+y1zDLMfsOtp2v83aCMQXsiQK1xtAAjyvf9OniyBNd2bLIYm5luV5sckGzSv/k
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB2488
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 23, 2021 at 08:14:15PM +0100, Christoph Hellwig wrote:
> >  static struct mdev_driver vfio_mdev_driver = {
> > +	.driver = {
> > +		.name = "vfio_mdev",
> > +		.owner = THIS_MODULE,
> > +		.mod_name = KBUILD_MODNAME,
> > +	},
> 
> What is the mod_name initialization for?  

It is usually hidden and works like this:

 /* pci_register_driver() must be a macro so KBUILD_MODNAME can be expanded */
 #define pci_register_driver(driver)		\
 	__pci_register_driver(driver, THIS_MODULE, KBUILD_MODNAME)
 
 int __pci_register_driver(struct pci_driver *drv, struct module *owner,
 			  const char *mod_name)
 {
	drv->driver.owner = owner;
  	drv->driver.mod_name = mod_name;

> I've not really seen that in anywere else, and the only user seems
> to be module_add_driver for a rather odd case we shouldn't hit here.

vfio_mdev could be compiled built in? 

AFAICT it handles the case where THIS_MODULE==NULL so we still need to
create sysfs links to the built in module.

If it is left NULL then a few sysfs files go missing for the built in
mode but no harm done?

I think it is correct to have it

Thanks,
Jason
