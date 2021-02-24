Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FFC1324362
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 18:54:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234839AbhBXRwc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 12:52:32 -0500
Received: from mail-bn8nam12on2045.outbound.protection.outlook.com ([40.107.237.45]:31740
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234727AbhBXRwY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 12:52:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DinlUDxHOBUnJY9WN857FJ/6m/fuH/9855X05KgI+YMaXy/22t6ZcI0f44tDCTyDprCGeBO/+ZNCMhkvva0oGXrbId+ohmofUvFF8bRJ1j6Hl6ulK2lORX7pC0i2ihZyOzgN+AhwADY3lYplSrbNNthI1kQ2S6o+PUfMqjD4FTj7PbnOxG/ECJOuy/g0goeTeGQq5zn3Xt3YrYVSVoLJ0xu6zVW4YmdJP9flP4gQiGxDCU+WOXHSsS6qb7zEXG5LgJS9Ik7PWsJ4hkWfb6/cvc5lQPhADuuVB+0Zw1uWAN6dYXLuJ6X0jp6B7LqogrW9Ad6oMqt+UqWnxixGCkwdFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qElMZGp8pFGrlNjxhk56GtfA4ZJd/R2FNf89qhJnKL4=;
 b=UNObxUnyRQqhX0xtQFXflkBAxVVXPWmHRjXOdUO/FwmrxBvrBuDQZn3TXwdM6HLb2BUnaTm+zNk2Xv+GEZwhv5Gu/A7niD90AsMkZKI1iACu4/4a9f1u9JAJ2Bnx2DsAkz0UFBv1shdOQhkE9xLX3nIxx6ppA23l+gK/fD23JHKAcY5n8e+B4jZspviuHbXQNc3mIQoSv/UGew47cfjHhryKcWSa0vg2tYpYuc+dDOg6031+WDKmwl9ceE0JuIhF0SJVYLcblpiWfJgtSLqvx5U6s4pK9lTCjq/2kPlJoP8hF+yvRFR5O6EhDtiD0HGmCpuDXDVCWGBk1NjM6qDfvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qElMZGp8pFGrlNjxhk56GtfA4ZJd/R2FNf89qhJnKL4=;
 b=m1Inv6ROHBOEcP3Brhxkok80RSWBJcZwO1a3kbbYF6jZ9GxJkxrQUT78YddFyrYEPluKZWPKtkAunFmzcdKKcPXxM1GnnQ6gjjkLT9Br13JnX5EyxEpJXNOZ3m+jCS966poC/7crv+19EFV1gOFv+EgFZYNz8vivQYIzjhSZDXc=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN1PR12MB2366.namprd12.prod.outlook.com (2603:10b6:802:25::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.32; Wed, 24 Feb
 2021 17:51:29 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3868.033; Wed, 24 Feb 2021
 17:51:29 +0000
Date:   Wed, 24 Feb 2021 17:51:22 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>, "bp@suse.de" <bp@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "srutherford@google.com" <srutherford@google.com>,
        "venu.busireddy@oracle.com" <venu.busireddy@oracle.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>
Subject: Re: [PATCH v10 10/16] KVM: x86: Introduce KVM_GET_SHARED_PAGES_LIST
 ioctl
Message-ID: <20210224175122.GA19661@ashkalra_ubuntu_server>
References: <cover.1612398155.git.ashish.kalra@amd.com>
 <7266edd714add8ec9d7f63eddfc9bbd4d789c213.1612398155.git.ashish.kalra@amd.com>
 <YCxrV4u98ZQtInOE@google.com>
 <SN6PR12MB27672FF8358D122EDD8CC0188E859@SN6PR12MB2767.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN6PR12MB27672FF8358D122EDD8CC0188E859@SN6PR12MB2767.namprd12.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0074.namprd11.prod.outlook.com
 (2603:10b6:806:d2::19) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SA0PR11CA0074.namprd11.prod.outlook.com (2603:10b6:806:d2::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.28 via Frontend Transport; Wed, 24 Feb 2021 17:51:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: dc4b8188-eb94-49de-cc8f-08d8d8ecd005
X-MS-TrafficTypeDiagnostic: SN1PR12MB2366:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB23664D2901BF6A0BCE030CDD8E9F9@SN1PR12MB2366.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x06Bc82waU7ifM0D6RoQbR+B3xh5VozU99LueunldKiKsxEneXLSKkVOHRjz73D5PwGL+Mv4UEkwkBwFOOSccwdYrsE9hLdtVUCSjCbhpiHQ4IjhR7l+VJPc1PHKJBrRcSjOhDPsCDhyweIOabAPX8EBDPTSydzGMOXUL+F5buHfVpR2LmvhteXZ2W/Ap00zbsDDNxVH2+p99jx/NqPx6KNhrAQac4QitmlKPylOWXVjQZgWUoh9h9yItjPaON5xciu05IyRNg+kJRVmPFwITBU+1ccCvBpeBUjUaeOhaoX9nDy4TmFNrTsI8xJoN8CtIr6+tC247jhclLeourTdtxJiPRKKYo0DiIqopLKYDLgmme6V5fngduQmUI5nNlGg051w0J+BFXXJtLgJ0pBnOSHZm+eFmrZQJ3oDEzujvA5+U4v/tVE+K18KomSZxVT84BO0OqE0y4UZkq0DSWEnPotpg8r+qq0ePigUXODXKpRmSlWKYDzytrmiFKpg5rdmWNW6H96v/9zGfrevMsOi1w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(366004)(136003)(39860400002)(66946007)(66556008)(16526019)(956004)(66476007)(316002)(6666004)(55016002)(1076003)(8676002)(478600001)(33656002)(44832011)(5660300002)(9686003)(53546011)(186003)(52116002)(83380400001)(7416002)(86362001)(8936002)(6496006)(2906002)(4326008)(54906003)(6916009)(26005)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?fu2V5l82Od5/F7q8EPhhyGjGjdQYXPkenkl4+q82amWWI17FgROdiR/xhAnC?=
 =?us-ascii?Q?EhVQRBw0bFdQzs5Zt9l7CTDkRcvohTGK/Mo9V/8sTOi1K6cElcp/APwF+eQh?=
 =?us-ascii?Q?vmiQJ/WpQ1kvLKZa3kRaAfZUYxwm60Q5nLFQ8vf8k82keYDOFEiM8Rt1W4M7?=
 =?us-ascii?Q?uWylnc5Qo6eEoJVJjGcVqj9ldM0NL3ZheGsdpyPNl/YACpwXKUziR9rj+dIU?=
 =?us-ascii?Q?3jK9i8N/Uogiqj0K1i8JZvOGV3cirw1XHYjBAxdQj5O7tZ3R93bKGy1TD2ng?=
 =?us-ascii?Q?ZtSrMATibtTIDVaprwzd19EI6pI0PJNz1z2WqBTqrGUnBtDKcOvtqqVUsiT9?=
 =?us-ascii?Q?CRMmoqwZ1/lZ88jXwmctMSuM9gSWxiJRCDPerDZRBoTABQl6FR7BPXDPqcEQ?=
 =?us-ascii?Q?nV/8Pv9BAqtHu6XsJtLC1K3dMqk4KmYjVuwlQQ94gIfN6E+32HbtrdWZDKlz?=
 =?us-ascii?Q?93743AruIuygYZIYU2w1k3N0AmYYxYFwiUliuzJZEbcePqTK+44gmdqP2dNu?=
 =?us-ascii?Q?h5QylvBJvFWbF/VytRaJq2W1HWvYNATKYvO2VioeO2p7LWaWmKiNF+1rNDG/?=
 =?us-ascii?Q?tmKQmOAjqcMjQyKZum7mRJLS9p/mKu3/QNy0bCebryfxjDM7WstEE+NcN60/?=
 =?us-ascii?Q?rSdzpdZblBMO5f0NhjZS+0iVmYOnvgn9IusyQ0IJbrZ6yHz+BCaKDG2CEKtj?=
 =?us-ascii?Q?xWZO+UyZADB24gMP2XURIgRZ2Tp0596myi73rhGeH3h9UX4RJcTIfv1LeWmf?=
 =?us-ascii?Q?1GUzLP/uAWdrSNfAHIcXqVF3INHB0aM6XU+kAq+pFT6GbO9DEHiews7cKs3T?=
 =?us-ascii?Q?zt5AGBz4TNOl0BJd8seB17hajbCAscv0+Il7PqyB70DvRYz1g0M2RTw+HkkX?=
 =?us-ascii?Q?AHat0YjYUZxjVPzKyllt+O1bCbhL/53SD8zJ6FSM6ZEurPdKBxav/wY/9obR?=
 =?us-ascii?Q?KAFnw6QndK7KkjtSSoICW0ltY9rHrUQCPeoY24MFPrnwR6K238zz7HYl6afw?=
 =?us-ascii?Q?Zimt6MmbIcc2Q9v1URMERGEsTNgHhQcJp7310A52lhUoomyefkacfasM7dZ1?=
 =?us-ascii?Q?yKr9U17noq/O5O8kiJixJXOk/9VfQyeI4Haly4a3wBS3FeY0gw2ZGTja2abq?=
 =?us-ascii?Q?zCip/qATbrYceuOObGviZPJaz+QVmE8wX2+pmVxT/Hcs0xc9/KDAESEto/3y?=
 =?us-ascii?Q?8gLFtWBWDlJbR9teP00Y6yBxLl47WC0EA3/0ylIwaJaKiAibAblg/gF7S+5S?=
 =?us-ascii?Q?rWbunqJUqxNib4Tw8rzWjVumhYW8omYtb37f5+psWPFsGEPFM62+Iwf60BBu?=
 =?us-ascii?Q?ES8JAgPeRcKHBgf9iteW325x?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc4b8188-eb94-49de-cc8f-08d8d8ecd005
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2021 17:51:29.1029
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5bmSjRJaiCYPnxdlPlcEMfZrWnMxwMUgLqRbXTqSIRE3ndPgqpviZgWDaoEijjphxQg70elMulBbr1jJYwkX3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2366
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 18, 2021 at 12:32:47PM -0600, Kalra, Ashish wrote:
> [AMD Public Use]
> 
> 
> -----Original Message-----
> From: Sean Christopherson <seanjc@google.com> 
> Sent: Tuesday, February 16, 2021 7:03 PM
> To: Kalra, Ashish <Ashish.Kalra@amd.com>
> Cc: pbonzini@redhat.com; tglx@linutronix.de; mingo@redhat.com; hpa@zytor.com; rkrcmar@redhat.com; joro@8bytes.org; bp@suse.de; Lendacky, Thomas <Thomas.Lendacky@amd.com>; x86@kernel.org; kvm@vger.kernel.org; linux-kernel@vger.kernel.org; srutherford@google.com; venu.busireddy@oracle.com; Singh, Brijesh <brijesh.singh@amd.com>
> Subject: Re: [PATCH v10 10/16] KVM: x86: Introduce KVM_GET_SHARED_PAGES_LIST ioctl
> 
> On Thu, Feb 04, 2021, Ashish Kalra wrote:
> > From: Brijesh Singh <brijesh.singh@amd.com>
> > 
> > The ioctl is used to retrieve a guest's shared pages list.
> 
> >What's the performance hit to boot time if KVM_HC_PAGE_ENC_STATUS is passed through to userspace?  That way, userspace could manage the set of pages >in whatever data structure they want, and these get/set ioctls go away.
> 
> I will be more concerned about performance hit during guest DMA I/O if the page encryption status hypercalls are passed through to user-space, 
> a lot of guest DMA I/O dynamically sets up pages for encryption and then flips them at DMA completion, so guest I/O will surely take a performance 
> hit with this pass-through stuff.
> 

Here are some rough performance numbers comparing # of heavy-weight VMEXITs compared to # of hypercalls, 
during a SEV guest boot: (launch of a ubuntu 18.04 guest)

# ./perf record -e kvm:kvm_userspace_exit -e kvm:kvm_hypercall -a ./qemu-system-x86_64 -enable-kvm -cpu host -machine q35 -smp 16,maxcpus=64 -m 512M -drive if=pflash,format=raw,unit=0,file=/home/ashish/sev-migration/qemu-5.1.50/OVMF_CODE.fd,readonly -drive if=pflash,format=raw,unit=1,file=OVMF_VARS.fd -drive file=../ubuntu-18.04.qcow2,if=none,id=disk0,format=qcow2 -device virtio-scsi-pci,id=scsi,disable-legacy=on,iommu_platform=true -device scsi-hd,drive=disk0 -object sev-guest,id=sev0,cbitpos=47,reduced-phys-bits=1,policy=0x0 -machine memory-encryption=sev0 -trace events=/tmp/events -nographic -monitor pty -monitor unix:monitor-source,server,nowait -qmp unix:/tmp/qmp-sock,server,nowait -device virtio-rng-pci,disable-legacy=on,iommu_platform=true

...
...

root@diesel2540:/home/ashish/sev-migration/qemu-5.1.50# ./perf report
# To display the perf.data header info, please use --header/--header-only options.
#
#
# Total Lost Samples: 0
#
# Samples: 981K of event 'kvm:kvm_userspace_exit'
# Event count (approx.): 981021
#
# Overhead  Command          Shared Object     Symbol
# ........  ...............  ................  ..................
#
   100.00%  qemu-system-x86  [kernel.vmlinux]  [k] kvm_vcpu_ioctl


# Samples: 19K of event 'kvm:kvm_hypercall'
# Event count (approx.): 19573
#
# Overhead  Command          Shared Object     Symbol
# ........  ...............  ................  .........................
#
   100.00%  qemu-system-x86  [kernel.vmlinux]  [k] kvm_emulate_hypercall

Out of these 19573 hypercalls, # of page encryption status hcalls are 19479,
so almost all hypercalls here are page encryption status hypercalls.

The above data indicates that there will be ~2% more Heavyweight VMEXITs
during SEV guest boot if we do page encryption status hypercalls 
pass-through to host userspace.

But, then Brijesh pointed out to me and highlighted that currently
OVMF is doing lot of VMEXITs because they don't use the DMA pool to minimize the C-bit toggles,
in other words, OVMF bounce buffer does page state change on every DMA allocate and free.

So here is the performance analysis after kernel and initrd have been
loaded into memory using grub and then starting perf just before booting the kernel.

These are the performance #'s after kernel and initrd have been loaded into memory, 
then perf is attached and kernel is booted : 

# Samples: 1M of event 'kvm:kvm_userspace_exit'
# Event count (approx.): 1081235
#
# Overhead  Trace output
# ........  ........................
#
    99.77%  reason KVM_EXIT_IO (2)
     0.23%  reason KVM_EXIT_MMIO (6)

# Samples: 1K of event 'kvm:kvm_hypercall'
# Event count (approx.): 1279
#

So as the above data indicates, Linux is only making ~1K hypercalls,
compared to ~18K hypercalls made by OVMF in the above use case.

Does the above adds a prerequisite that OVMF needs to be optimized if 
and before hypercall pass-through can be done ? 

Thanks,
Ashish
