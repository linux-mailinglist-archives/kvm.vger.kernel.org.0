Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC98E5133B2
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 14:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346253AbiD1McD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 08:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344818AbiD1McC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 08:32:02 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2062.outbound.protection.outlook.com [40.107.243.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F81AF1DE;
        Thu, 28 Apr 2022 05:28:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d1gc9SM9SWuPoxxURHpXE5aRdE4dcY7tc9WU3p3zmgRvHrBwzuX7hUVnCcwRYO7TAxgVZpYklS61mMk2CHgUy4/b7rDh8fMP89XyZhQUfK9A71XCgwJ4m2zaDNyoMFK/lZKIQy+ohsqdz4wDiwBzdGUBrk9ERCM/ofWClqKiE80Y9rF5VjG0W9udfnu7UYpT+/GLozhu+O2sGlFJdaQpgT9fAcFg4G/mpkPYzf3WPAcwAxMcH5NuE1KIrmitDzgwkUMmWzc+pJLxUcnpSEfbdDR/V+MhT9OnL+ihV7zdgId7nh6H8z9B7ucOFKr9/sMkXYeBv8w//elh18IalkueBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nXdLk7+Ybyay59j04Lb9oGkSSsCcBaQiRn6Bihnil1s=;
 b=EzJSxDwVQ4lwFpL0fWbUxF6ju4nzr+gwm1BQ6VCZhbO3eqvsa8dI6ZJh9pWxaAJl40D6FIi8Uufc6sRnCRiqPxNmIbWupROVwxtrq27xmQJSxIXeWCRzjPuqWNZeCROIeT4KlOoGIWVniUdg+CIUlABWIB6zgdkjI8Wf/6LsPebaf0ahRzZPlkHit/F8Fc7SB8Vprt3U7GWUuPsDsAekIZPCovDZRfAA+EvaluX0MxeL+h2mKxCHICzuc+XSc+PUJGQYIVhhSBNvLDBBwLQ5wCgrphYv1Lv/Jw2nhp/bClZAInWFhXQRfmH/YXdQ/vKgNybKataC42e9e4VYrERYnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nXdLk7+Ybyay59j04Lb9oGkSSsCcBaQiRn6Bihnil1s=;
 b=WhrXoskqtzIgxVHShOWPL2lsX/0qgYmF16Db8FMQQrZZL3XEWFDLhsiqEvMB7ZcN9oiWoRfgEWoS9iwnVTrnizclSItBTWw5Poiz/23Cp359q4sDuaFWSZsCb4lhVXVP0t0LcObtvW742I6EG/RmNJgLkp0Wd5qct/leIYztwQlVlDTYgOH9hFXzDhY2UxTIifB3sDj4ifRGj3uYx8dD/X+oXkLhgc9X0Ib1Lm+ha7n4e5RuqIM7bJCLdIJ77k6Fj1QJcx/599TUeQQIyDmLUjD49b9Pulv9Es1wVXAwfiV0cWLl7PonAP9vtq7KAqDguopS3t3yHfJoBCOnAX8N0Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by IA1PR12MB6068.namprd12.prod.outlook.com (2603:10b6:208:3ec::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.20; Thu, 28 Apr
 2022 12:28:47 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5186.023; Thu, 28 Apr 2022
 12:28:46 +0000
Date:   Thu, 28 Apr 2022 09:28:45 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, alex.williamson@redhat.com,
        cohuck@redhat.com, schnelle@linux.ibm.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, borntraeger@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v6 15/21] KVM: s390: pci: add routines to start/stop
 interpretive execution
Message-ID: <20220428122845.GC8364@nvidia.com>
References: <20220426200842.98655-1-mjrosato@linux.ibm.com>
 <20220426200842.98655-16-mjrosato@linux.ibm.com>
 <20220427151400.GY2125828@nvidia.com>
 <b9575614-a234-0c36-7601-9c09d159c3b0@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9575614-a234-0c36-7601-9c09d159c3b0@linux.ibm.com>
X-ClientProxiedBy: BL1PR13CA0432.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::17) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 07789a3c-2a5b-4203-2c4f-08da2912a3fd
X-MS-TrafficTypeDiagnostic: IA1PR12MB6068:EE_
X-Microsoft-Antispam-PRVS: <IA1PR12MB606849786B017DAB6300C06AC2FD9@IA1PR12MB6068.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8kM5uLCW+8ue53JR7wdNbQCxQpB5ZbSNuCAr2AWzVqCSuaEQkbzyDLeC2hmUY8qIUkj/GfdL0CIeS0DgvpdjsVmUneQYw7lfRCFOMoieIGky7hbD2AjbldehRNnw07mIQGMSxQnw+6tgDKfsM3LxcQ/MSxho8Zqj/PPP2e4ge70llZ9VwvOd8Xjekyw/fRE1IuTJpc+tpY0qlDdVCUSbAsJwYPJUSaCyiXb/x2Ze/NDMzCffToCUMAI+ahBWsayjrW0PKmlfltP6D1bts4ELFSBYVnN+DhreQPtqD1UDpBWJYaujdFPmhBaNbNWftPri64Gz2Dve2ZzsbzZz1kr0Mc11OICq+SDWBKpTq5qKo+EGh0TBLdoG51yHOiyCoA3sUjtY7bNtiC7TNxSrKGXRva5eFO9dgRFEpfg6L3BTamYnF9qF5Y3ONmtRiVH32VgDfdDiV4pJIOTcCCEH0fFQs2P5lUO7kBS368BNbLf8ECvMVCi5cXkk82Bakva8UEFTT/0z/xzSAu6bP2euOuNnrljnwQZojBfz2HB9kjA06G5lkHRgW8uCzOAKfXl8n0JpjS+GWVKpcLjtKBhbzgFXbEw2GUJWxSNZQ0tm8wzxTjVsdwEf3SuJr0+XhFBoVoHq2IvnNB8JakV6hJmdP/Y61g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(8676002)(2616005)(66946007)(316002)(5660300002)(6916009)(7416002)(8936002)(33656002)(6506007)(508600001)(66476007)(66556008)(2906002)(83380400001)(36756003)(1076003)(26005)(186003)(6512007)(6486002)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/sZVQ50Qs1XMAuHOpj8cKOl4MqzhhE3KmNhKTQQTAEiaVdzAOFNe6j+i8uiP?=
 =?us-ascii?Q?YuUPI9bSXRl1F4Sv3YnOlElYkaTaf3iGvQg2B1pytCdGK4fLStLRE/nvR3e/?=
 =?us-ascii?Q?qbjav+6IZDYDzK9YgJsEholfae5jw9xT8PP5rVNcoRjcK1jsHP7Lk9VuVbF5?=
 =?us-ascii?Q?/NldSBCDS6P6xQLuYti/g55isVsBD9vj+/Rcmmk3BUGLFg0crK2+fx9S9u6F?=
 =?us-ascii?Q?hHMdWKeWMO/KevS0GSngS5fZYnNoM3Ap4xy2mxCi+nlLZQK0JpAQRfOT1UQj?=
 =?us-ascii?Q?9BaOIkPd8HEj3CQf2f6OnrCq1g5PvnqFQhIrfBFhKhjq6+nnwBU/F9rX9r1p?=
 =?us-ascii?Q?k/PkpCT5IYGPk+IZuD/D2K//ZJFXU+IgTLo61lGG6Jo3DI/deG+aJwQ1juoS?=
 =?us-ascii?Q?Xc4+0nD+msttgpE5C9C1fnxKUXyV0jkNk7FLENeE8Te1PduYWBC4RlAr6XoB?=
 =?us-ascii?Q?Te59N8edGzCfyJfBvExNAx02Z6LSUgex+WaZIKWIhCSpHsxoIgtRnYh+x8tg?=
 =?us-ascii?Q?VY4fLTNZ+2xXVAvkLxk5XTqc3lh8oFQ0iaTYCUAerJCY+rmf+gIynOjiU0IN?=
 =?us-ascii?Q?3J21lEdzb6vlDrOXJfTlYRvmX9k/K9yrNE/90mkfsduzSAEXJHe79pTc0Bj1?=
 =?us-ascii?Q?A9tqsLle5ynbU3Lw73OxzARtJa/HXpRP/n6rI3VM1ZpzEX7UWC4SO8Sr0aMD?=
 =?us-ascii?Q?MyKBDfvI6VBzXtuve3/yRwItz+JrMvCYRK7nE9Cfr7jNuwm/8x6u+samyP7T?=
 =?us-ascii?Q?mak6GG16DlPWno9SNhz9v0C3ppPaQeDlMXo496UULMDD92bEfmTJFrlh+6Uv?=
 =?us-ascii?Q?gjjmk3hdbqwW98ZxxPUVuwE+Fvvajqn/5Yq7iWD0z26t904eyVkSBXX3Y3XE?=
 =?us-ascii?Q?//XX0iwA3Fsm06SVhlkeUE9e6T6XXdorU9PJHmRuK+9WoHfGlbKUalSttZNw?=
 =?us-ascii?Q?knaMEYELb7S9jIkVYJieDgBCzn26Pyk5+nPc5ovwSZij/sC/qGzZoNP3SlmE?=
 =?us-ascii?Q?KWvMs7jCD3hBIHQCkkMe8DlwQCU/ySeYmpSqjRoEQjWAyu9FRb1L2iXfUcaf?=
 =?us-ascii?Q?ioCv1eFqMDWP776RNoZk6GTzEjNx6TFlcz+8C3T2DgkovfvU3QHW8DTvr6Ok?=
 =?us-ascii?Q?Po7t8DZrL/6ponig4Jphf0B1iS43nsSIQWVoZZ87SMTDe6+vo8Btir3G5JaA?=
 =?us-ascii?Q?OzBXYFSl1HiOba6NVne+MX/WPuKd2JH40LGvT8OTtit7wt/z2hyG8uBAvOi9?=
 =?us-ascii?Q?l+jNx60KGNoBfvPLAZmBsODZZto1HpRlbNu54kj1HUmRRW/nlYLbfj7BZT+F?=
 =?us-ascii?Q?9+L2W9g6n/cEpL5NSOWhVU3pcT5CvJFgmxq4UKVVW0qP/MopH+FBtaM7Q/NN?=
 =?us-ascii?Q?8PXV+B/Zlq86gO82KbGnSoV3mJz47d0nXDQA8Mrutw3tMzR2OACkmPifkbS0?=
 =?us-ascii?Q?21SAc+NR2reEejWCui5AssQ74L6SwsFlidvAv9Qh7x6KcwUsOeJDj4NJp4Sv?=
 =?us-ascii?Q?tjnuBlo3Xd0GAGBcpVZSF7jVYcR0P+SBVh2zCTRuVxEDFgQeKPfQX7vq6Qb3?=
 =?us-ascii?Q?lPo2djPIji4pCDEOX6PAJp1Ah/J7da5gs88Kk0aBLHus5T/2fHmXFK6nw/gE?=
 =?us-ascii?Q?/RxiN/EArdSZ4ZBKaeBUHDVIiVK42yqouwrrgMR166EbefRKYrSfqcZ52s1v?=
 =?us-ascii?Q?LBYdc0EBbzC+vwKVKhSUqGtJFj6RI0Yq/g+BFreP22I+HniwP+kIDLRQ7UFy?=
 =?us-ascii?Q?HE6SaeVNvA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07789a3c-2a5b-4203-2c4f-08da2912a3fd
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 12:28:46.6586
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O43qztaJo4VguTV639NGBVmfCIP9W0MQYWDmr2z5y58VnqKFnXWnNZlKk/7YurQi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6068
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 27, 2022 at 04:20:10PM -0400, Matthew Rosato wrote:
> > > +void kvm_s390_pci_clear_list(struct kvm *kvm)
> > > +{
> > > +	struct kvm_zdev *tmp, *kzdev;
> > > +	LIST_HEAD(remove);
> > > +
> > > +	spin_lock(&kvm->arch.kzdev_list_lock);
> > > +	list_for_each_entry_safe(kzdev, tmp, &kvm->arch.kzdev_list, entry)
> > > +		list_move_tail(&kzdev->entry, &remove);
> > > +	spin_unlock(&kvm->arch.kzdev_list_lock);
> > > +
> > > +	list_for_each_entry_safe(kzdev, tmp, &remove, entry)
> > > +		unregister_kvm(kzdev->zdev);
> > 
> > Hum, I wonder if this is a mistake in kvm:
> > 
> > static void kvm_destroy_vm(struct kvm *kvm)
> > {
> > [..]
> > 	kvm_arch_destroy_vm(kvm);
> > 	kvm_destroy_devices(kvm);
> > 
> > kvm_destroy_devices() triggers the VFIO notifier with NULL. Indeed for
> > correctness I would expect the VFIO users to have been notified to
> > release the kvm before the kvm object becomes partially destroyed?
> > 
> > Maybe you should investigate re-ordering this at the KVM side and just
> > WARN_ON(!list_empty) in the arch code?
> > 
> > (vfio has this odd usage model where it should use the kvm pointer
> > without taking a ref on it so long as the unregister hasn't been
> > called)
> > 
> 
> The issue there is that I am unregistering the notifier during close_device
> for each zPCI dev, which will have already happened

And at that moment you have to clean up the arch stuff too, it
shouldn't be left floating around once the driver that installed it
looses access to the kvm.

> -- so by the time we get to kvm_destroy_devices(), whether it's
> before or after kvm_arch_destroy_vm, there are no longer any zPCI
> notifiers registered that will trigger.

I don't think that is strictly true, there is no enforced linkage
between the lifetime of the kvm FD and the lifetime of the VFIO device
FD. qemu probably orders them the way you say.

> One way to solve this is to have the zpci close_device hook also trigger the
> work that a KVM_DEV_VFIO_GROUP_DEL would (if the device is being closed, the
> KVM association for that device isn't applicable anymore so go ahead and
> clean up).

That makes the most sense - but think about what happens if the KVM fd
is closed while the device FD is still open..

Jason
