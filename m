Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3053B5262BD
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 15:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380609AbiEMNQ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 09:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232625AbiEMNQ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 09:16:28 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2084.outbound.protection.outlook.com [40.107.223.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 074EB65E8
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 06:16:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jt9AOo2ouXZtMjCQG7UdvbVDaHw4IyNnGUaNzvkUXU94NdBX4OVLowis1WLxxFzjNUkbT8ABgBNHJ3pNZ7EbmTwPm5RmKlv7CPlsDNQIUSGRKteCreo1G06vzs0oLiiNyR4lNXJYvKYaEDnAUhGmlfDcoIQq1uW7EC4o0aXc95N0aG82lU6aGwDIfidZVch6qxHjQA6KTH+qvpwSsTjitJARpJVL9Wof0uHliG6X7AP/QsaoDhmvwFJHOb7qH43qOZnAh5nm6rRP27Jjd017yLFjsb+ZAK/c4dXspPebzLWdHh8IswmWFscWcmGWTUTGdVgsKCowA63oQMiNpOsluA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MPgqVwY+wAE0M5/JYUpmNzrPFPJPonwmCaGebwWnM5k=;
 b=Gwftr5weY332HGbBKu9pvjx5qfYzMpgjP/pNN+fVfM/HwQXtkMJRyjIbmx4fmZCIeEkxHXbWAVG/us4iiXL44X+jPoEcDmUnL/YodGLa60/iQj/JBAkwn/9MMwXtHe4FTmoKJ6S6icdYe3KakceYbCzyxVF3sGFQBSBwriGoVK+nc0nFYDDVyQ8l7vMrtJoDHLYhj9+E0cc3V+qYU1p7N2MQjy0jnsPd28pLQhZJ24JW3Sa+oCjvweIh+4nmVYXbcall/AuD1U6Bst0GscMC13jwAKdYLD4IFOt92ERxxlE5NAzQG6zb1MGQkymtji9xmiEQbZrpQIZrOwDzHFLf7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MPgqVwY+wAE0M5/JYUpmNzrPFPJPonwmCaGebwWnM5k=;
 b=qt1awfVMtNiRuTd+sfrCMss8fKOkBg0ZL5QwwgLrA6nEbARclBj3AUMKPlFgUueedh1351fqFTUublUu4WpdJshjilx+Q9QZkmhjFgzSAYi1WM+e00Lm7qvYlDUPoEP25/wCMUFF//4Cx+7dbX5ErCvbmc7JZa3hjNI4E8WlToFfMj2nxEddwRsmYX/b2d9NTaPPWsE0FM96RV/O8fA81kUhHWHoYfMfcDUldmjR+iMOm7//rj4UdA3uJELrKikk5ZZb4fCPHLou/r6P1me3Cv5oa+YNDrBygsYX2qazzST61CHw+8vvSljemny1Nf1wGbIsaSDWUav5sH2457ZYQA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MW2PR12MB2570.namprd12.prod.outlook.com (2603:10b6:907:a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Fri, 13 May
 2022 13:16:25 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%5]) with mapi id 15.20.5250.013; Fri, 13 May 2022
 13:16:23 +0000
Date:   Fri, 13 May 2022 10:16:21 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Xiao Guangrong <guangrong.xiao@linux.intel.com>,
        Jike Song <jike.song@intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/6] vfio: Add missing locking for struct vfio_group::kvm
Message-ID: <20220513131621.GA1457796@nvidia.com>
References: <0-v1-c1d14aae2e8f+2f4-vfio_group_locking_jgg@nvidia.com>
 <1-v1-c1d14aae2e8f+2f4-vfio_group_locking_jgg@nvidia.com>
 <BN9PR11MB5276C75E8FDB277D5BD6A42C8CCA9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276C75E8FDB277D5BD6A42C8CCA9@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR08CA0007.namprd08.prod.outlook.com
 (2603:10b6:208:239::12) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bbaf6440-d725-4379-8f5e-08da34e2c6d3
X-MS-TrafficTypeDiagnostic: MW2PR12MB2570:EE_
X-Microsoft-Antispam-PRVS: <MW2PR12MB25700474EF610B78DC7C8E6BC2CA9@MW2PR12MB2570.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zPksFZh8Zwn+B18p6r9KhCPw6FOTgRy7ifSNyS0MElXGgTx7m0i0Xa+mJklwxc7wfgxYGRZkekbGLpAVWXIjvK6dN8/6gLR6itwwrB5gJB9aQTnaiuZLUIPp03YcFwJFNfxEqNfT/QnI8lTmecY20mjm4osuSDs1ydx0bcduQH2GMVGyf4HGL/xCflHY4HViZ7FJSSqueQqsFhOUDNJJt8T24+/uZX9v2/UMsOd0ZOE1UBnGwrMO58pyO3Uo10yn4aKpWXFyX5BOB7yHARpWOQ1+u185j5VTuHQwUzjIMbJSExfCww1w3UpdEabLI0QYLNlSPBbJcmixQvKqm/bCuiqzqgybPez4UU8emArBgzrFfqK0VhfIZbvIwPUO5Y3KKt8rc3xalmdCs2Au8hGyaYdpVE/MaLl5DHoKRqbAfuhHhvzvaIWmeUSOElMU/S8GLUwuYnoWpZHCD8r1kdf7waUeDYpG6LfLBdWYZaWkpfyJmS7okVgH+PWIMYYeRfKDJf1bov9h4szAEUoEXVsKwFca9RoEYzjam5OTLNES6KsCTqS2SOrENfAHeioYQQdC4+lCY5AvgnXqQtorepodULO7ucLxzN8K8H3T7EyyqptvhmBgI7Ndo/NNowk0mGDGmBW2zD6Ca4NNTG7/1BympQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(66476007)(66946007)(186003)(66556008)(8676002)(2616005)(4326008)(38100700002)(33656002)(6486002)(5660300002)(2906002)(83380400001)(86362001)(508600001)(8936002)(26005)(36756003)(6512007)(54906003)(316002)(6916009)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gnSYk3D5dop/cAqVNxr4YG2KWpBfO3KJiqRseu+pdTXXVpXOwJa/9lhSVaU0?=
 =?us-ascii?Q?mKNPMrcTLOyEI6YtFn94jxVkPPOusvbeQJ9U7z+qIDb1uMOCGj4LzjNVZCMb?=
 =?us-ascii?Q?ueU+mJ+f84hi3msbFxYFMGzkZlTB9sYkehILPdvo73TaBtqBLVE3h31n2n+w?=
 =?us-ascii?Q?mdww9DT5PuPr2OSt/cY32IPPPo1p6xnN9zAQDFk85o4mB+UHUCXXnf8evoNg?=
 =?us-ascii?Q?l1MbN4inDGT5u34n8/M7QQ2N5fVna/Ts1tnk+8jzcsD1D5+oz15O1EhdgSSZ?=
 =?us-ascii?Q?FoS9aeefF6tePF0KbCSm/TFw0bzkSWz4kze60ddUgpTVPEwMH8WUy816Xun1?=
 =?us-ascii?Q?MlRp1B6iouqvfIpUSnONp1HYOtwQerlu75xj0MVOYJWaCASbATXNryl92RAO?=
 =?us-ascii?Q?O0Wppm3T575rf8As1jistAuTXfTSshHb467Vno/InX17SI8bJCMgXpoYfewD?=
 =?us-ascii?Q?kWBX2KZ6UYiyiysrCm3rg/YuU+rmsjIfA14YggSW5JEA9CFMe8p1Yq53UaC4?=
 =?us-ascii?Q?7/ng/he8DIE33eoHRHVVjx/fEOufFmMZAd4iFyQsZtmNB5E7TQCpOvF5ou+V?=
 =?us-ascii?Q?cIopON8PJTgGchXZk31yBtInwKLGyWK/8ejUYud5z846AoDP8qbDG+GBHMu2?=
 =?us-ascii?Q?uvarvMQ/M2Mzipa5fBVB3IBW4246Fc1ay8Nm39ngugWFgHQSi5q9s7b1BY0p?=
 =?us-ascii?Q?QbyEVx8a9neMBzoZdcPcRZY3DM8d4TDNeXdsUQC5qp+dqT9HKr9oDFoSAC8P?=
 =?us-ascii?Q?In63hbSezi427d5URZJvmLHhYgtYid9VyWsuX3E7L8Hcm7C3cRJ9rZcb74+m?=
 =?us-ascii?Q?TWrspr3RHUPI0d/iHUr+HPOxcuLtWeSfqKkSfhQ9/9pr4KTvVKDOwkgXBjsx?=
 =?us-ascii?Q?XebTNhCjj+BV+Oao2wY8MJzQ8it3RJhUY4LYmiJq8KKZvIEkx1GKhzSWO3oy?=
 =?us-ascii?Q?SsxCkFeKVbqh9Gf3CyjVoBeyd8LvIn4EUysIgAjQ4RCY8LkwhnfP49OEqKnb?=
 =?us-ascii?Q?a2VVlGMCMg3CKJpHfITTuEO+8K299v7AeazbyG0PcTvYqKa7xZ7zgjKZz/UY?=
 =?us-ascii?Q?0C7D+wH6feH3/c01gYdpX4IIBasaq4DNCSd+uwZlYtHGe8Zu1KGEVKyKBugo?=
 =?us-ascii?Q?c3n86ITw9YJOkhztgmB9sBpmWqTSo/Tnc0cMI2bYIc3jRTJd1k1sIC5ipW47?=
 =?us-ascii?Q?dTiQyQO2zE67KpoWZ9NX/AoqfBbHoOcrrGnZV3Z3os3fl053n8CT6B0zG+zA?=
 =?us-ascii?Q?XFKeXLqgQdlD2uYpWeg6gvtW00am0ZqoYgnJ8vXhxb7UDTgQUQyWyg5UKnr0?=
 =?us-ascii?Q?J9WE2DyZh3HGlC4rgVwkdx3MIPokaxzOR6jmCfbjGpr13bBC+QBweA49S8Wt?=
 =?us-ascii?Q?RChZ8XiuDEgxF8nXYeWn/je9ah4eaoTXPK4fJB+cmBGN9CyLbGEBSuok5KWD?=
 =?us-ascii?Q?fc2K9PgLTEoGxuQUGbS2QXP8Qa+Td/0t8jX1H5GQg5Z+oMLwhKYk+HNYsRmb?=
 =?us-ascii?Q?zJq4u5HLhw33VHTFmA94szznKax7V01Yf2JtONxZjrglFzZkVz25neCquqrS?=
 =?us-ascii?Q?zEQNIJz2MCJTDg1GFjapZTE9azYAT4++KAx12tlV7G7bgYAkzKO6LNoOQQtE?=
 =?us-ascii?Q?fUPCuQxwbEefgSIFqTMT8I/ruQZ1FQ3OTHwoMPXBGbgEkK/CSXRcUqzvvSRh?=
 =?us-ascii?Q?vgAjYEAvJ/9mW67N1TQhuNwVhrrDK7DkCFFlRUByJB/rsCdJ5Dl9Uuz+qtYR?=
 =?us-ascii?Q?gRo0PZo+jQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbaf6440-d725-4379-8f5e-08da34e2c6d3
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2022 13:16:23.0905
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CRYDV7Usjjbwx58NjaEfxkoGyUsv3O+pxwiwf1SEdegZ1dth5fzWzENAvEjFqJlu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2570
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 13, 2022 at 09:08:06AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Friday, May 6, 2022 8:25 AM
> > 
> > Without locking userspace can trigger a UAF by racing
> > KVM_DEV_VFIO_GROUP_DEL with VFIO_GROUP_GET_DEVICE_FD:
> > 
> >               CPU1                               CPU2
> > 					    ioctl(KVM_DEV_VFIO_GROUP_DEL)
> >  ioctl(VFIO_GROUP_GET_DEVICE_FD)
> >     vfio_group_get_device_fd
> >      open_device()
> >       intel_vgpu_open_device()
> >         vfio_register_notifier()
> > 	 vfio_register_group_notifier()
> > 	   blocking_notifier_call_chain(&group->notifier,
> >                VFIO_GROUP_NOTIFY_SET_KVM, group->kvm);
> > 
> > 					      set_kvm()
> > 						group->kvm = NULL
> > 					    close()
> > 					     kfree(kvm)
> > 
> >              intel_vgpu_group_notifier()
> >                 vdev->kvm = data
> >     [..]
> >         kvmgt_guest_init()
> >          kvm_get_kvm(info->kvm);
> > 	    // UAF!
> > 
> 
> this doesn't match the latest code since kvmgt_guest_init() has
> been removed.
> 
> With the new code UAF will occur in an earlier place:
> 
> 	ret = -ESRCH;
> 	if (!vgpu->kvm || vgpu->kvm->mm != current->mm) {
> 		gvt_vgpu_err("KVM is required to use Intel vGPU\n");
> 		goto undo_register;
> 	}
> 
> 	...
> 	kvm_get_kvm(vgpu->kvm);

Right thanks

I just dropped the kvmgt_guest_init() since it is all in the same
function now.

This needs fixing as Christoph suggested by making the KVM some
integral part of the VFIO so it can't just randomly disappear under a
VFIO driver that requires it.

Jason
