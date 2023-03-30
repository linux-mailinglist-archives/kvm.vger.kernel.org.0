Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9056D0F43
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 21:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbjC3TsP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 15:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbjC3TsM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 15:48:12 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2054.outbound.protection.outlook.com [40.107.223.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85F7AFF3A;
        Thu, 30 Mar 2023 12:48:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ilf6MrZ4xDRr6pj5i2NCNnOw+1rEHPORwLUhdL7E/GDfOIkwKLO0f4Plc1ZeaEoREmiskwHUdHp7IKsPSoAXjbwj0RifKrpe4HffCmfNp39TfuvEadkBRzeJn4dGHUWWgoNV3vA1D8KyRi321MrUuZzvjvcn7xc99zxUk2cT7Hog6Nt+3mfNTWpAX3B/abh63Qx9smSoHtL3KL78IqXy3F/jGNE3w7XP4+B3mK9pbBDGuKaIIqLxanDaaalbbZKn0HTqwWWQVPAYvb/YxG28AtXVmVCji0k23lfKFSMsAa6nBNha72HsGUMFQgOQO55RC1BMau3Pi6mxYKEUtiqmGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cOI6Gi5IUZpJJsoI7+vJQDw7iAS8FCcOB+q+yg7SYA8=;
 b=NnucIaLCUUi2cK7lUsfKdpR76AzLPGrAh9gHW2u2u//yGb0Y+3rN4wR8M4AezCtNGrH+roVupMMu27fkw32TXRk0i1J1vHujH9F5WRUoikK4pYeoUY1a/6TvQ4LG+oIVbW+iePMlkpImeey149AB1a5hqPVLnhWPgI/hnU760KutJmIK0vComsvw2d7Wv0VuJUylU0+RawETulsqUP3fZ4BS34USShNqJwhj+6WM62pa8EzUUeFCN2JuAWRfCCP9teT21msdiR4dkaZKbmsVdnMHRd70ntzAOz4lH0RYz3cGNY+bHYd7dt9Po3p6mBZkUY83Ij/xHfibUMqY9004mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cOI6Gi5IUZpJJsoI7+vJQDw7iAS8FCcOB+q+yg7SYA8=;
 b=gG4xszFu4zjM3euCU6ehp41kTthvMpKrEv8JKxk/DIdoMYDaXi0QlpmDq9Ncesl6X6B2mcKLKEWleTclll0dFTASsEqIC7jtmM2cDO3qD00O6RKnwa/ywEIBD9UBpjLwYtBhAeqnlRbOeJ4ullTrqpYOO/9DSAh1DOHbcsQ2Zew=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20)
 by SJ1PR12MB6265.namprd12.prod.outlook.com (2603:10b6:a03:458::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22; Thu, 30 Mar
 2023 19:48:07 +0000
Received: from BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::de95:3582:8274:ff60]) by BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::de95:3582:8274:ff60%3]) with mapi id 15.20.6222.035; Thu, 30 Mar 2023
 19:48:07 +0000
Date:   Thu, 30 Mar 2023 14:47:46 -0500
From:   John Allen <john.allen@amd.com>
To:     "Yang, Weijiang" <weijiang.yang@intel.com>
Cc:     "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, Borislav Petkov <bp@alien8.de>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Christopherson, Sean" <seanjc@google.com>
Subject: Re: [RFC PATCH 0/7] SVM guest shadow stack support
Message-ID: <ZCXnYj3GsoB1Kipo@johallen-workstation.lan>
References: <20221012203910.204793-1-john.allen@amd.com>
 <Y9B97dZnFnjEHhVf@google.com>
 <d4e15021af4e72d6daba4021feaebf289b676830.camel@intel.com>
 <ZCMpJLAx8//1zLLV@johallen-workstation.lan>
 <b75c6f20-a99c-a6d4-c1c1-7ae9f016d2af@intel.com>
 <9cf73a9d-d9eb-c6a6-a083-88539a3e78a2@intel.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9cf73a9d-d9eb-c6a6-a083-88539a3e78a2@intel.com>
X-ClientProxiedBy: MW4PR03CA0177.namprd03.prod.outlook.com
 (2603:10b6:303:8d::32) To BL1PR12MB5995.namprd12.prod.outlook.com
 (2603:10b6:208:39b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5995:EE_|SJ1PR12MB6265:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d15ef40-7daa-4abd-de17-08db3157af36
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sA513K7fJrWIe++IOq0z4tUOeBxAvvNnSpckX5Hy9qIVXbvjbAZ4k3iX6oBe8ui0l68teKzatEwtNTqtPQCqlP3o6dOBYey9vcczBy+Qzpue6DO2cnke5m+YdGRqbbmC7n1f1ts5aRNkBwEDO+o7+POGtxzQ+NFVJTbSEPAkdpUF0A5PjI9NpmzD+M0zEV+yWvqxyeDC/zMKx1Nxp3OymdbKmUl3a3I1reCh+NY5E+gZ8MITdIItFJtUxPB+Z9xoYGyiw91nQv/v7CVYWlz03ipj79bOPCQUT3VFCEkKclK5vSXTE29gcBywqsxk+ZlEoIV3KpO81VQ+Bs6u8JhFfJsg9r/gjcba11qczKTbx73hmrr92gDHx9FQYFTWDuP860qkES+UsZkI+s3/RAHPqqmd+vT4MaynerKYos+nYby97sgxbjZWdIaMXFPixpb3XvTYwtdtdM3v/xUcB5TANm1yo32tJ1qrLPXxFmezXTCMfBS+HE9dafImkF16as/EwiehiavJ/48D/jDooti013HHVMChyVVsxKbx20baljjQtsagTcT9okDsaP8Ct8xJFHeeznozfDr/Nmb1eVyBcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(39860400002)(366004)(376002)(136003)(451199021)(86362001)(83380400001)(6486002)(966005)(478600001)(186003)(54906003)(316002)(26005)(6666004)(53546011)(2906002)(6506007)(6512007)(9686003)(4326008)(36756003)(44832011)(8936002)(6916009)(38100700002)(66476007)(8676002)(41300700001)(66556008)(5660300002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?yvr4FfxilCQlHGy5bOEKYOP3mqDFU9OqjmsJd3la2q8bPI56Mklpgt1INf?=
 =?iso-8859-1?Q?oQJ8KBFrzmeBYjuPhNfoG4EuaGSyjzHMsBTWJqBpiO6Qf47yFImevxpxoj?=
 =?iso-8859-1?Q?jHu26zHUozeTLZV4klMSiuCiKHP0hqcHFrGuvcAW02EKYdJZjmwCxua8yF?=
 =?iso-8859-1?Q?YLYGoJztmwJ2jROv3zHpYVeUOdLD9j0bzMlkAZSIOiQY+L15jpZHHAgrrw?=
 =?iso-8859-1?Q?ycDz9Ey7neYJZba6j0hRpikycsXB1/M6t7Svq4H/xACXHxKDQuLkg/lsKc?=
 =?iso-8859-1?Q?GvPc+fWqKWZCnYhg+l0YAV06Q1QPhprVP0WzVITihpSLcEhrPtrEvNJCpO?=
 =?iso-8859-1?Q?cehiUSrckTIp51MwF4I8Rh/jaydAAHauZl6ZvuDd7U55y7ewH7VIvTcNmt?=
 =?iso-8859-1?Q?49BGMRobOgG+4HhsWhxMOdeJEVrpSgU+S8f3HN+QjVDiDLsZr9XsVypy0p?=
 =?iso-8859-1?Q?i5D06xCwDPL180hUq90vu/wKCitDFAkdfCbspXwNdaFEg+Kda8prFgmYnp?=
 =?iso-8859-1?Q?W4fLG6HwPGOtRy9gYbqlrwkMNK3rzpNqpL5BEizsKdXjJKWnxrsiZFABV2?=
 =?iso-8859-1?Q?ZM8U7gt3FFUgMIvPMaOC26bZOfEJMhGOvYq5zRfLS/rIzAAwLcacl7wkk2?=
 =?iso-8859-1?Q?IlKHXv7J+zat6LwIK+2nGEerZGC4+0bw6A7+dYehmNKnhBrCGCbKpUnWgb?=
 =?iso-8859-1?Q?0B/URA2TbHa9DrXecQff21Md4fcZSzhY4E5znqJo8drbSrSwVqWnXcTobU?=
 =?iso-8859-1?Q?7aourQh0OoyNg+w/42Er9v+/jnbYLmI0fEG03KWWrqi5f5SJgW5ikkda/Q?=
 =?iso-8859-1?Q?Sg8jRsFstNOXh56Vr7VVd1bGczxfPg9c7CuL4z2qH7XmgK5ab971K9wJz1?=
 =?iso-8859-1?Q?B7hD1R1W8cO41U0dTGXOozemoSJWetQgiT/RkpBtNl91aGkI0T/qQNzmqV?=
 =?iso-8859-1?Q?M02xN1J3gTCrWaRBX0XoDV6kpURAstMkAiKArU23Lr9u2qBkvXonhAwlkN?=
 =?iso-8859-1?Q?9eSb2tpbJXD/jpq7IkqUAvpCm4o2Ee6tAAVg2gpeTwBP92LZTUqMpWcR1O?=
 =?iso-8859-1?Q?iFxEDK5mTweOKDhDBQMn4ahz+GoCp4qvBvTfE2RAg0Cku/wqGu3GANZ1hH?=
 =?iso-8859-1?Q?SbxNOCmKEa2o3GrYRTcvVNb/OsWEK75urgdp8D5WSZtQPgWVFYrP8Np83X?=
 =?iso-8859-1?Q?cvvkikG15odN0tTP93ArlOqmFKLgQbRQmRkHvFRqWKAzv7AU4BPC5lZ0fd?=
 =?iso-8859-1?Q?g05SDMHG73be3kznWlvHfBC6uE32hf1xIAxvSPqvQb15nkq6x+V30tKrlf?=
 =?iso-8859-1?Q?va5Gah6Z+1j7iKLvYC+FeP1DLHl5GLG2tLAYWLpm04FUJyx/e3Kmuflsma?=
 =?iso-8859-1?Q?rZjAjkRV4E5JBrwRGi8ZYh7xzyE7cLTSgoKKXGCf2fYlDs+yaAbOS49F9E?=
 =?iso-8859-1?Q?V25/PQIN18SiCRy3MMLp8HRWX7mprKb7QLAaai2uY1Z/dKqnIZjmE8L+TN?=
 =?iso-8859-1?Q?Y3Hfl+WJH9LwgqodC4AmTeqht53EwIB3Nhmru4qXcBtKzLwdMClVdrntMK?=
 =?iso-8859-1?Q?bNzCRr+FjUTVVa98zsZN3yXHMdl3JME6NvZ036+wiISutp39rhPOr+O2iq?=
 =?iso-8859-1?Q?viZOSCQUba9uzMFE2yIzWd1ow1YgMX6cRX?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d15ef40-7daa-4abd-de17-08db3157af36
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5995.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 19:48:07.7465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: avZpZFEx6oznhqB0Me9Nfc+0sPF7HcHdKKVTu5zhUiZHKoc22HVwTwEGnHqlu+EJayfi2Z3HgimRhcQzJVDGTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6265
X-Spam-Status: No, score=0.2 required=5.0 tests=DKIM_INVALID,DKIM_SIGNED,
        FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 30, 2023 at 01:37:38PM +0800, Yang, Weijiang wrote:
> 
> On 3/29/2023 8:16 AM, Yang, Weijiang wrote:
> > 
> > On 3/29/2023 1:51 AM, John Allen wrote:
> > > On Wed, Jan 25, 2023 at 01:11:44AM +0000, Edgecombe, Rick P wrote:
> > > > On Wed, 2023-01-25 at 00:55 +0000, Sean Christopherson wrote:
> > > > > On Wed, Oct 12, 2022, John Allen wrote:
> > > > > > AMD Zen3 and newer processors support shadow stack, a feature
> > > > > > designed to
> > > > > > protect against ROP (return-oriented programming) attacks in which
> > > > > > an attacker
> > > > > > manipulates return addresses on the call stack in order to execute
> > > > > > arbitrary
> > > > > > code. To prevent this, shadow stacks can be allocated that are only
> > > > > > used by
> > > > > > control transfer and return instructions. When a CALL instruction
> > > > > > is issued, it
> > > > > > writes the return address to both the program stack and the shadow
> > > > > > stack. When
> > > > > > the subsequent RET instruction is issued, it pops the return
> > > > > > address from both
> > > > > > stacks and compares them. If the addresses don't match, a control-
> > > > > > protection
> > > > > > exception is raised.
> > > > > > 
> > > > > > Shadow stack and a related feature, Indirect Branch Tracking (IBT),
> > > > > > are
> > > > > > collectively referred to as Control-flow Enforcement Technology
> > > > > > (CET). However,
> > > > > > current AMD processors only support shadow stack and not IBT.
> > > > > > 
> > > > > > This series adds support for shadow stack in SVM guests and builds
> > > > > > upon the
> > > > > > support added in the CET guest support patch series [1] and the CET
> > > > > > kernel
> > > > > > patch series [2]. Additional patches are required to support shadow
> > > > > > stack
> > > > > > enabled guests in qemu [3] and glibc [4].
> > > > > > 
> > > > > > [1]: CET guest support patches
> > > > > > 
> > > > https://lore.kernel.org/all/20220616084643.19564-1-weijiang.yang@intel.com/
> > > > 
> > > > > > [2]: Latest CET kernel patches
> > > > > > 
> > > > https://lore.kernel.org/all/20220929222936.14584-1-rick.p.edgecombe@intel.com/
> > > > 
> > > > > That dependency chain makes me sad.
> > > > > 
> > > > > Outside of a very shallow comment on the last patch, I don't plan on
> > > > > reviewing
> > > > > this until the kernel side of things gets out of our way. When that
> > > > > finally
> > > > > does happen, I'll definitely prioritize reviewing and merging this
> > > > > and the KVM
> > > > > Intel series.  I'd love to see this land.
> > > > I think all KVM needs is a few patches from the beginning of the host
> > > > series (the FPU stuff). At one point Weijiang and I had discussed with
> > > > Paolo and x86 folks that those few could go up with the KVM series if
> > > > desired.
> > > Now that the baremetal series has been accepted, how do we want to
> > > proceed? I think I'd like to send a refreshed version based on the
> > > version that was accpeted, but I'd want to wait to base it on a new
> > > version of Weijiang's kvm/vmx series (if one is planned).
> > > 
> > > Weijiang and Rick,
> > > 
> > > Are you planning on sending a new version of the kvm/vmx series?
> > 
> > Hi, Allen,
> > 
> > Yes, I'm working on the new version of kvm/vmx series, will cc you when
> > 
> > send it to community.
> 
> Patch 1/7 did what I wanted to implement to support AMD SHSTK, my next
> version
> 
> will continue refactoring them in vmx scope, then  your series may pick up
> the helper
> 
> and modify accordingly.
> 
> Please note, in my series, I removed check for MSR_IA32_PL{0,1,2}_SSP since
> they're
> 
> not supported right now, but your series supports for the MSRs, so you have
> to change
> 
> the helper a bit to adapt to your patches.

The reason we decided to include the PL{0,1,2}_SSP MSRs is that even
though linux doesn't support supervisor shadow stack, a non-linux guest
OS might support it and could make use of the MSRs. It could be
something the vmx patches might want to account for as well 

Thanks,
John
