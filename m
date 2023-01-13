Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF7A669B33
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 16:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbjAMO77 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 09:59:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbjAMO7E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 09:59:04 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2062.outbound.protection.outlook.com [40.107.96.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5909172784;
        Fri, 13 Jan 2023 06:49:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NjQ4fkuFfuFYB325r3wuJsdA0/Ssw9Tpm1aWuV2QSTA0R2r+noau4UAd0mQmnjpJD2ivQp7VZDxP2SsJMHxQTcgRONameOc5w/eYtqBqh2Op6EUdeD1uxWz7YHJfn5qJp44qb5OgrhUblErEkHSaZcTwe3qEUzQIJuX6C5Sf8pBx9w5ZmDDPaoQ2JMXEQ6k+MEZGrWZURIuRdzqSCILKrT6sO4gaOjD5MLzEhAeGKtm6hamr4XdUMp550eVwwCxIocsa4NZ+QYtIceorty2Uh54VR9YC2CW+YD5i7vnffOiNb/PzP7fSY2gCUSUvByCnAwFILDdbH+rXC1D4f1AO3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8m5rPkoZH3/wJvGZhFphkkCAAR69hnXUvL80vrF0ObA=;
 b=MvT2yvb9VoClCSP6QLosxubfErED+llu3u7n1r+GHaWLcsGsOREPpuVylpa4aJjTInkBRF9c1vEpMm9y/sRLImJ5iwyUHjPyrBZd72tGOHJzD8NMAUjlM08/iz1EdV2l64KEvQqv02FFDsFZ0QY8KWEmY4WPXDaeFqO2iY6HNtF+uuSD78cC/MFAF8qC7gzxDYUrWRgapCoVf832m4p1UvPmzQJ2IVxLgGgA6HputZdeoLa43kawdCX1eEXolvaO0ebESF2JlLGlA6UljbYJG+bIYsaW88XiQ/NLnrWgp54SRnZb4vbyfkB1MvvfkBq3kfijMM/ffodRz5YBd5tSPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8m5rPkoZH3/wJvGZhFphkkCAAR69hnXUvL80vrF0ObA=;
 b=klR2WBz+PTUIrIGmrO9tTxvbVH2cSQjhvWikOv61iG7lVL07CNYKPQDrRKxbCnxNZxyMGQjMN+nsoUh0s+WwcrGs48pYeerFeN/Sq0HlhORLPAG3R4Id0AUPM7QDwJod0ViZdkVj2JdE+zp9X+s6HZRDK8PZAF2aodHFKFR9/ZJvuKBAiscghT+CbKJFeXFqA5tVbaz+WrqPKj0Pldoqyp/3l6f5NyCzLHGlVax6ad2GWBxXci2fufP7lB11JTXaU1jgLWnuo/KMf0M01Hd3f6mdl4hAgMIWTqMeOvXqRXehhIAvp/EQ5lIuwbc5VEYzIdrZpIQ30DfDbkMRS09WwQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY5PR12MB6382.namprd12.prod.outlook.com (2603:10b6:930:3e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Fri, 13 Jan
 2023 14:49:07 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.6002.013; Fri, 13 Jan 2023
 14:49:07 +0000
Date:   Fri, 13 Jan 2023 10:49:06 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>, pbonzini@redhat.com,
        cohuck@redhat.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com, akrowiak@linux.ibm.com,
        jjherne@linux.ibm.com, pasic@linux.ibm.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] vfio: fix potential deadlock on vfio group lock
Message-ID: <Y8FvYhpIRIiX22Op@nvidia.com>
References: <20230112203844.41179-1-mjrosato@linux.ibm.com>
 <20230112140517.6db5b346.alex.williamson@redhat.com>
 <bce7912a-f904-b5a3-d234-c3e2c42d9e54@linux.ibm.com>
 <Y8CX8YwT/T9v4U/D@google.com>
 <20230112175648.158dca5f.alex.williamson@redhat.com>
 <Y8C8WpkjgFelldTQ@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8C8WpkjgFelldTQ@google.com>
X-ClientProxiedBy: MN2PR15CA0053.namprd15.prod.outlook.com
 (2603:10b6:208:237::22) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY5PR12MB6382:EE_
X-MS-Office365-Filtering-Correlation-Id: c294d0d3-7fa7-44ba-0ed0-08daf57552b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o2Oqm2VXp7fo0Viw4QlVVOpg+P+eNh42pnkP/16EfHs0BULR/iXuq/6y9ZYsXqgi/i/ufPR2GZFmyOSP23kit1QrcHA3GkszEupezDB1/wv2p7rwgQSA2QF2RTtlI53pLNU7wViR10Chcvi9bhDZAR+5vOiGarUQ5CqQIzrCsyweKfrLa83dzNYsuJZWAJq9zhnVGObSNh4aLKaBJ+NvOJkTLT5ryMPkb32tr6CPE40h/rg58BX3vmhU2e+zb/HUgHptjPscvGtlk7H+po6RvZmWj1eFE2mUsXsTFk258j7nFoJgE/47Fivxd+tFI7ZLGKJUsZvmbDWVfBpNeVVTUtnxXOIIIwADoXbh9RYnBy5sC8NcJ2MX5RnYxshsvfDD8+nBz0djev9JEEes3L6LEXJcTarZfw7dP3dzyAXfUubbhbnRTY6upUs0LDAkKA6V2mec1EEW3nrL6o4D3H/nWjbj/wqo+TAoYxVw0owqoo0k9CMKbVy7uj5f/XcDWYyQALg51im/Xa5ikhbfXr2RPUT/9qQwiUNS+Slcjb2EeSiTW65v0iNkO+yqoBmDVC5nnHaFiLBsK8tp8Iu/MxM+W3xTSNAPz1j4cGVnOynFZ5jkMDxJ5k4AQLZxwF+abkQVKffd9XX7Dpes2GFIBLlAlg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(396003)(346002)(366004)(376002)(451199015)(26005)(6916009)(36756003)(186003)(53546011)(8936002)(2616005)(6486002)(6512007)(6506007)(5660300002)(66946007)(66556008)(66476007)(7416002)(316002)(4326008)(41300700001)(38100700002)(478600001)(54906003)(8676002)(86362001)(83380400001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D3Eu+T/J4rp95pnTWZWBiqqFDBfY1p+lumNoKL9HsOVdy2UyIf1qoajsf/T+?=
 =?us-ascii?Q?0jE3KW38ubQm1b1cUEVwFAAp5JGhKgj3umEdw12sHlXdkdCxC1QDatsB4mwH?=
 =?us-ascii?Q?bmsPwkVikDj810mcOWvEUTx+inn7iI+MFn09+Qm5UqLunBpXJc+9WkORJGhp?=
 =?us-ascii?Q?UKue8MDg4bNd5N+FHsWXaVJiOnOkmYt4u+fu5e6qclHgBkQn2LIunhXJfsYf?=
 =?us-ascii?Q?wKJNL3AZ8A62++0emm0xit4j3VcBiUxw9078JQ0beTmKMwMPwwIsANnlhTPR?=
 =?us-ascii?Q?G+XIWcU9N5z2xrGXXvTaDwXMz47BLH9rGb3you6beM4q99gXHWhiIMbu5yoX?=
 =?us-ascii?Q?rUwMGXmx3xTm1CvT/t4i19f17swQfE/cYLwJeqVR+infhTgzwm0hPLjxIi6Z?=
 =?us-ascii?Q?gUCec1QiqOjclrLs/mCckZaWsSWcv+G+iru7wGxpjF1LKu8fQItV7bt5WnLi?=
 =?us-ascii?Q?rZooUzOzuhPKlIjpG4ikYADMTiqCtKruzZu4Xb8F4uEgTMrSTFJnD3efJ8k/?=
 =?us-ascii?Q?Hdtcez9AZjl+G9iazcprK8zjVVXg9jx/mZn6Fdy0ghktioL4bbn0m4maERYr?=
 =?us-ascii?Q?KoXkqvrcE41xBjGtdGebpmStvNjWYPLRUsjocS/nXmMNhEPTrKHzbph9/DId?=
 =?us-ascii?Q?COirjAYfEUbZ12ncuXFG1DRYgb2vafpd5OI9BtaxrEGbhmNYLdi/018N0OAl?=
 =?us-ascii?Q?6tAW3zLrdgd1f2xaUJahS6X5L9yVxckHlMGCd7Wz6TH8OIh26vFdfb6WuxVR?=
 =?us-ascii?Q?6AEiJVqOAD/QMlNq3RTlJKjwXNmV9RAvn+jxrPqNm64V09RxQ+rWM+kYFxc0?=
 =?us-ascii?Q?vkA3DXNSw1Lpf654jiSVuDSeIjfq2gBkj8QjXcFy0qPBFN+M+5BMslukBomP?=
 =?us-ascii?Q?8kCgN7R8ih+2is89zm3I9aDYwb5sGdfE6CuJ18xTRID4nfh1jRDZSZv5Vg7g?=
 =?us-ascii?Q?RR4BCtEXXeX5HEz4QmdDmz5HYgb3GVyY3EXqQwQbzrWGINtlm+BoHNGNvF1r?=
 =?us-ascii?Q?m+lkpIF5xDNfRXisoavZQcALorEYs3pvRZn/Hqt9lcEelutbqMR388kDzTx1?=
 =?us-ascii?Q?8/u9PeTinv2nYMruihCxR9iuvsqNxgvm1cdw7z/CQucAlPWeGV4Qcw1Lssoy?=
 =?us-ascii?Q?CUH6SDFO95O50dW3TrGRHjuoTbxhEWvP5WCZPhezy3CZ1wvan/OFaqFHMS7L?=
 =?us-ascii?Q?DVo/yaowoOjhX5w5F4rOYgdIERQURTxITD1CoNLRrOur/a3Bt86wnA9qHwgY?=
 =?us-ascii?Q?/q5eM5Lem9IwP+nq877A8p7GM8H9Cc+g8YjmNJVpScC8mbEazMHT2oM4Oqvo?=
 =?us-ascii?Q?mpSXdLcq/IJZjLi+u1uZnRhCjKXRhwYOlXQ/7HPJQWfuXqcbzmxdskm2lRtU?=
 =?us-ascii?Q?laNGFSrSKmAVfeq0dJeSOfBXLniopmQefKhjcOj64I6z61EywwnvrDXHhR6t?=
 =?us-ascii?Q?vGamSW/GbSDnBBHpesKCRwk7KCt92CFJqzs15FspL9xzJxU0paGThJZPpNna?=
 =?us-ascii?Q?657y0IcaEfTMr9d7fytmb0bprJpUDtqg6IJgfIqW1zgQQueAieKGEuOniJLQ?=
 =?us-ascii?Q?N8rjtvf8j/Yj3JH5QuYjDxRkKWSk+7vGbsDBJ8Zg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c294d0d3-7fa7-44ba-0ed0-08daf57552b8
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2023 14:49:07.6150
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2z1J7xWDyEUNrek56bdz+ZNFV5GQ8jZRwNjt8P2U51I65/3YKLIrvyO/7g/w7zTL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6382
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 13, 2023 at 02:05:14AM +0000, Sean Christopherson wrote:
> On Thu, Jan 12, 2023, Alex Williamson wrote:
> > On Thu, 12 Jan 2023 23:29:53 +0000
> > Sean Christopherson <seanjc@google.com> wrote:
> > 
> > > On Thu, Jan 12, 2023, Matthew Rosato wrote:
> > > > On 1/12/23 4:05 PM, Alex Williamson wrote:  
> > > > > On Thu, 12 Jan 2023 15:38:44 -0500
> > > > > Matthew Rosato <mjrosato@linux.ibm.com> wrote:  
> > > > >> @@ -344,6 +345,35 @@ static bool vfio_assert_device_open(struct vfio_device *device)
> > > > >>  	return !WARN_ON_ONCE(!READ_ONCE(device->open_count));
> > > > >>  }
> > > > >>  
> > > > >> +static bool vfio_kvm_get_kvm_safe(struct kvm *kvm)
> > > > >> +{
> > > > >> +	bool (*fn)(struct kvm *kvm);
> > > > >> +	bool ret;
> > > > >> +
> > > > >> +	fn = symbol_get(kvm_get_kvm_safe);
> > > > >> +	if (WARN_ON(!fn))  
> > > 
> > > In a related vein to Alex's comments about error handling, this should not WARN.
> > > WARNing during vfio_kvm_put_kvm() makes sense, but the "get" is somewhat blind.
> > 
> > It's not exactly blind though, we wouldn't have a kvm pointer if the
> > kvm-vfio device hadn't stuffed one into the group.  We only call into
> > here if we have a non-NULL pointer, so it wouldn't simply be that the
> > kvm module isn't available for this to fire, but more that we have an
> > API change to make the symbol no longer exist.  A WARN for that doesn't
> > seem unreasonable.  Thanks,
> 
> Hmm, I was thinking that it might be possible for kvm.ko to be on its way out,
> but barring use of force module unload, which breaks things left and right, kvm.ko
> can only be going if all VMs have been destroyed.

If we really care about these details then we should obtain both the
get_safe and put together, the put pointer should be stored in the
device and it should be symbol_put'd back once the kvm is put back and
it isn't needed any more.

This properly mimics how normal module stacking would work

Jason
