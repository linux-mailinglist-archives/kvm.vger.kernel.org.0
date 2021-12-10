Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A469F46F825
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 01:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234953AbhLJAum (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 19:50:42 -0500
Received: from mail-bn8nam11on2042.outbound.protection.outlook.com ([40.107.236.42]:32513
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234930AbhLJAuk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 19:50:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VvXn//vVqT8Y1QjcwnKgAy0nqRXlxqULNaTFO/pEBascLM1ml61gTEYDiqZHnrvBsvE+36IgdvIjZSkusd37hIZN++CBNxbklr50za4jmhc/+QAvQE2qxT951Mo7GaG+DplOdHl2HiaGHkFrGWUOkxMYlmru2XezGRqdWODnmSYU9MOhAR6cPa5und5GpOef4bz+CmbsXB2frOW9qNBGCS3U607GNE6xyW4XWtX9PvCiJS9V7cO+cqPiaknCDceLNSdzLeEbrWT4vKginNDIA/FEUQckq3l6d4qiRoOHg5f+s7MuqgUYVIyUNcb1ow6qwxmFnbnFNGM/Z8t4ouppUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IaDWplH4hQtieiGhZa9RNzQW8oIF2HBW7sbY/lLzqFs=;
 b=Mty4CIvidBcAaq02O6npcvzUNdalZtaesl/j+BHega9qG8fl4gc9KBSLhwq2/f1+MubBCbhbh6doTlFXS3a1+FDgi7ODZJV5EIgIkmqaNUOtHKgoaRWCWvUo7fX0A+VTgzzIwYLxVVWmu6rl4Ms9kYtHmOgT0rL66Mav41/uPhKoxFGq748l5crsFqqVmcuKzw6vJPNPaUhU4tjd9xM8O+GRyeR+Ul78qmQC8v/45GFpSwrw8t3Dl5zH8CJ5pNr0X8jf5wqKx0/hgu6Zbl1M1O7JoZySbJTnspwvVwjZbrZnhFuT3u2rw2ZW504p+fv9XtH/I6bHhCGgFLLOTbXhWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IaDWplH4hQtieiGhZa9RNzQW8oIF2HBW7sbY/lLzqFs=;
 b=GHK/3rdmKgOLTL49nrveogqG19lLKUUK7E6EDIxLrf2AHAl/oPzYyFjc/JiIL0qPK1pVGhvAtF3Uxk/2IUQIEFSGTpL8zimZ5WRPWa/TWIfEbn3XBZA4d6hvJAeUjXltu+nCYtSGCCssz/UGNEFxD2FB2h3YLP5iMJBq7r7BcZrZ/DQCcAXojey+UgWcCug1EesAIobRCXbJFsgfwycm/txuHpQLpANCzYORdIRgncO86bvyXTaVVR/oWrTLVNp24tbBksg7dasnMccZQC3XnMtoehkB823bKvRCK/Yg+2gNb1aga8pk5cW0+pa32Nwouh5nmyiyEfjOd+sZVRfy7g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5205.namprd12.prod.outlook.com (2603:10b6:208:308::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Fri, 10 Dec
 2021 00:47:03 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11%7]) with mapi id 15.20.4778.014; Fri, 10 Dec 2021
 00:47:03 +0000
Date:   Thu, 9 Dec 2021 20:46:59 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v3] vfio: Documentation for the migration region
Message-ID: <20211210004659.GB6385@nvidia.com>
References: <0-v3-184b374ad0a8+24c-vfio_mig_doc_jgg@nvidia.com>
 <20211209163457.3e74ebaf.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211209163457.3e74ebaf.alex.williamson@redhat.com>
X-ClientProxiedBy: YT3PR01CA0035.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:82::33) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d29e1d69-564f-4863-3324-08d9bb7693eb
X-MS-TrafficTypeDiagnostic: BL1PR12MB5205:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB520551A02F0B34B0A9474B63C2719@BL1PR12MB5205.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KDUUG6nsOjOjw+pKTuINrdsbEYz7TArcFc2AauWRiogC7HUCyHmd5pqzpZjwusj7nLpkvo5OwaN+wfmFprmqC44N0XO9U2LnAcJdLZcRXh44sega49Kw4JO2O6q6HFmDo9tSjn7sIxXnmq4I2Ybj0OCSeNEj53hM4XgVQ0GivF2QTS1/uWBznxjId9QRzonfWMvs7oPL+cqEZExsuKLPxrO6C9tox3O8PW1UzmoIp2SQsHJuYSWMPbknHh6vW30hi511BjpGFyGEHgM6cHUvats13gcSpyMIkpQOONjrlSBP3+KHLoAXKdwxjOhiiklX8TswYh7vk1cvwPP+7nLcvr8LmU5PdOtyToRcve2dyd+RBWvYHWMlCCruFgnpjDg4whZes7TjxppRIgldrwf8hQXtvUBSh2bDZ4r42xUN1AXoIBeWwTGGl9uL7wQEhcdxraJtQOVRHob9sFZDeV4wTh9eiWXJZ1NEys04E/8yxPIsE1cssgTN8ZPFHpHKCK0WPh3n+FXROxZpS1tgZZOlZ1gd0edfUDlSEBmzogX5ILh5cz6+hfwg2zVJ/wxAp2WIU+WQAtmC1HtlYk6L+5LyJzpal41UcVCPp87xQuahDcFHSR0LAsz88kmEojzUTCSWFJCf25vO5bQ6+sTiiRQbhg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(508600001)(1076003)(83380400001)(66556008)(186003)(316002)(26005)(8936002)(6486002)(2906002)(86362001)(6512007)(6506007)(6916009)(66946007)(4326008)(2616005)(38100700002)(36756003)(5660300002)(8676002)(54906003)(33656002)(30864003)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4vx48EuLS/WgdsXr+wLUjLaiyJWfHK5I6ALcAlbbgPqxiwQVhF2Q194ZjcjW?=
 =?us-ascii?Q?1ZxACJgSryZySAwWRqaUtljvAV/Lw//EUf6NA56fWBQqbVAI3Hx0Cgsz7KoM?=
 =?us-ascii?Q?guly1b3xqOyRRocvbxZgSHadXmrtS+SCAYVNEiJ6SZ3fRNRlqNYDnRslTiZ0?=
 =?us-ascii?Q?394830SG66hxILax4dx9RvSgto8i64LxUZdcP4YH500AAVsHJbpwZJ7Ip2Uq?=
 =?us-ascii?Q?5sTJiG1U40OJXS0gIqRA3XQBrHXrWGlaVxFXgpc3f0WlUkp/58ICKeddr4V8?=
 =?us-ascii?Q?GMPzP3pMEPIg1TcCD1lIujgpo+lx4jECXMemjhMPkMKHF+KDcsYUVqFCKZZs?=
 =?us-ascii?Q?p9vOfR2hRdYbEPzWSbK2ynCVBks23xTsug/ptz5HkZ5UgS2PwNbFsSZd6u+U?=
 =?us-ascii?Q?ZNc5OHwJyz4vVjc/i1kl2Z3XhJVeljihPoao+6SRNhIk5MN4lisH9qI7liys?=
 =?us-ascii?Q?XGOhhAkGtl2KDytt4J5PFnAMAixP+o6ESot6WdBOzneWAJDnYuLKyYUZnMwa?=
 =?us-ascii?Q?4kD7+znsaTAJTxxZoasweTSRbplhgXUmWkCz0Fdb5g8hWNRJERx15fUwst69?=
 =?us-ascii?Q?zc67u9KwrsXaOWYhX1RGKbRa/K8Axx8UuOjYH31JlL8ttTMBGfksJi9dvJ13?=
 =?us-ascii?Q?V9apvrxchzFQnYdBeeqn/s8+fX7TH2yDmuGjcfpP3tybwhO069rh2qCDmuYZ?=
 =?us-ascii?Q?1dPLdmbgj4FOtM6IKDmEBznTky8azOpQdjyelNgm5k1GQ7rGifikO3N88ua+?=
 =?us-ascii?Q?RoMXPafTGrqTUFN8SfCnw78+v+FxQhMGwfH8JJGwLVMzf0OqZIJPtgkz6L1Z?=
 =?us-ascii?Q?jJ9POic5u7RWDae4IJ1wYC3FJLbzUtVdNGXv8LS4K3zJSqHPU7oQRl23mD+k?=
 =?us-ascii?Q?TrR4RJIbz3NapZPajIvWIMmJqzQcuC4LWLo+EGQxE2IuvoixnY5ZotvPlNLF?=
 =?us-ascii?Q?+DaKfnOIbPdINPDRMeUZwIT3Y8sMgQcOnlNvAR0pmdHSFWvuiHKHunHhIEWW?=
 =?us-ascii?Q?iEKGEPW8j43eP5Dfo/SxjSqraJE20x0nEwYKL4dQeYQxwg+bO8SY3n1sDs/G?=
 =?us-ascii?Q?fecJPJMslVyrFZr3IKKwTb6X1gZkVjtt02U/LxV8n94EK70J4MntAGTa4dtr?=
 =?us-ascii?Q?eD5Z+9Lpcz5eNc93eXh1mdPi8Jf1rR4VyXkBXrG2VdHXvckv97HGO2NPXVPs?=
 =?us-ascii?Q?/yICwIjAqZ4SpgxPjR/kcxv7Zh56JleGWv19qa3mrXJhTmiSLBqaSirmLS7L?=
 =?us-ascii?Q?C7NluSoZgWG3TUn8NpU5hlFcoiouHLlBNgZebiN8kQv5eXVxqsw6+FGE2ZK2?=
 =?us-ascii?Q?nps5iDepTAxtt/LUWIgm9s4FCuXo4qO1jPZ/NH4880u1bpT1oe6GDx8SGym0?=
 =?us-ascii?Q?h8yRBVFOuIyTQuDC7Gq/8TGNDxA+xpsrvAZiQCPl99njaSjIdMk3tlE73Rjj?=
 =?us-ascii?Q?nSIbUVbfMGN4/cyHSCxS81wGUh/qX0v79tNt4w+hS+73JwgbsCebJ6BOrCq0?=
 =?us-ascii?Q?S+LkpaSqrP24ZV7DH+YIXzU/KUpOvU+CLZoK47pdSwyOp6rxslqythx7GbAg?=
 =?us-ascii?Q?ykjletqLwRfhtkGjHAg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d29e1d69-564f-4863-3324-08d9bb7693eb
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2021 00:47:03.5112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NBeYjPO1kqp5K3yfjXShh9ZKxXSqJfn+BwaoLVhowf95m7ibej/T9EycYKamJux0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5205
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 09, 2021 at 04:34:57PM -0700, Alex Williamson wrote:
> On Tue,  7 Dec 2021 13:13:00 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > Provide some more complete documentation for the migration regions
> > behavior, specifically focusing on the device_state bits and the whole
> > system view from a VMM.
> > 
> > To: Alex Williamson <alex.williamson@redhat.com>
> > Cc: Cornelia Huck <cohuck@redhat.com>
> > Cc: kvm@vger.kernel.org
> > Cc: Max Gurtovoy <mgurtovoy@nvidia.com>
> > Cc: Kirti Wankhede <kwankhede@nvidia.com>
> > Cc: Yishai Hadas <yishaih@nvidia.com>
> > Cc: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> >  Documentation/driver-api/vfio.rst | 301 +++++++++++++++++++++++++++++-
> >  1 file changed, 300 insertions(+), 1 deletion(-)
> 
> I'm sending a rewrite of the uAPI separately.  I hope this brings it
> more in line with what you consider to be a viable specification and
> perhaps makes some of the below new documentation unnecessary.

It is far better than what was there before, and sufficiently terse it
is OK in a header file. Really, it is quite a great job what you've
got there.

Honestly, I don't think I can write something at quite that level, if
that is your expectation of what we need to achieve here..

> > +-------------------------------------------------------------------------------
> > +
> > +VFIO migration driver API
> > +-------------------------------------------------------------------------------
> > +
> > +VFIO drivers that support migration implement a migration control register
> > +called device_state in the struct vfio_device_migration_info which is in its
> > +VFIO_REGION_TYPE_MIGRATION region.
> > +
> > +The device_state controls both device action and continuous behavior.
> > +Setting/clearing bit groups triggers device action, and each bit controls a
> > +continuous device behavior.
> 
> This notion of device actions and continuous behavior seems to make
> such a simple concept incredibly complicated.  We have "is the device
> running or not" and a new modifier bit to that, and which mode is the
> migration region, off, saving, or resuming.  Seems simple enough, but I
> can't follow your bit groups below.

It is an effort to bridge from the very simple view you wrote to a
fuller understanding what the driver should be implementing.

We must talk about SAVING|RUNING / SAVING|!RUNNING together to be able
to explain everything that is going on.

But we probably don't want the introductory paragraphs at all. Lets
just refer to the header file and explain the following discussion
elaborates on that.

> > +Along with the device_state the migration driver provides a data window which
> > +allows streaming migration data into or out of the device. The entire
> > +migration data, up to the end of stream must be transported from the saving to
> > +resuming side.
> > +
> > +A lot of flexibility is provided to user-space in how it operates these
> > +bits. What follows is a reference flow for saving device state in a live
> > +migration, with all features, and an illustration how other external non-VFIO
> > +entities (VCPU_RUNNING and DIRTY_TRACKING) the VMM controls fit in.
> > +
> > +  RUNNING, VCPU_RUNNING
> > +     Normal operating state
> > +  RUNNING, DIRTY_TRACKING, VCPU_RUNNING
> > +     Log DMAs
> > +
> > +     Stream all memory
> > +  SAVING | RUNNING, DIRTY_TRACKING, VCPU_RUNNING
> > +     Log internal device changes (pre-copy)
> > +
> > +     Stream device state through the migration window
> > +
> > +     While in this state repeat as desired:
> > +
> > +	Atomic Read and Clear DMA Dirty log
> > +
> > +	Stream dirty memory
> > +  SAVING | NDMA | RUNNING, VCPU_RUNNING
> > +     vIOMMU grace state
> > +
> > +     Complete all in progress IO page faults, idle the vIOMMU
> > +  SAVING | NDMA | RUNNING
> > +     Peer to Peer DMA grace state
> > +
> > +     Final snapshot of DMA dirty log (atomic not required)
> > +  SAVING
> > +     Stream final device state through the migration window
> > +
> > +     Copy final dirty data
> 
> So yes, let's move use of migration region in support of a VMM here,
> but as I mentioned in the last round, these notes per state are all
> over the map and some of them barely provide enough of a clue to know
> what you're getting at.  Let's start simple and build.

I'm not sure what you are suggesting?

Combined with the new header file this is much better, it tersely
explains from a VMM point of view what each state is about

Do you think this section should be longer and the section below much
shorter? That might be a better document.

> > +  0
> > +     Device is halted
> 
> We don't care what the device state goes to after we're done collecting
> data from it.

The reference flow is just a reference, choosing to go to 0 is fine,
right?

> > +and the reference flow for resuming:
> > +
> > +  RUNNING
> > +     Use ioctl(VFIO_GROUP_GET_DEVICE_FD) to obtain a fresh device
> > +  RESUMING
> > +     Push in migration data.
> > +  NDMA | RUNNING
> > +     Peer to Peer DMA grace state
> > +  RUNNING, VCPU_RUNNING
> > +     Normal operating state
> > +
> > +If the VMM has multiple VFIO devices undergoing migration then the grace
> > +states act as cross device synchronization points. The VMM must bring all
> > +devices to the grace state before advancing past it.
> 
> Why?  (rhetorical)  Describe that we can't stop all device atomically
> therefore we need to running-but-not-initiating state to quiesce the
> system to finish up saving and the same because we can't atomically
> release all devices on the restoring end.

OK

> > +Event triggered actions happen when user-space requests a new device_state
> > +that differs from the current device_state. Actions happen on a bit group
> > +basis:
> > +
> > + SAVING
> 
> Does this mean the entire new device_state is (SAVING) or does this
> mean that we set the SAVING bit independent of all other bits.

It says "actions happen on a bit group basis", so independent of all
other bits as you say

But perhaps we don't need this at all anymore as the header file is
sufficent enough

> > +   The device clears the data window and prepares to stream migration data.
> > +   The entire data from the start of SAVING to the end of stream is transfered
> > +   to the other side to execute a resume.
> 
> "Clearing the data window" is an implementation, each iteration of the
> migration protocol provides "something" in the data window.  The
> migration driver could take no action when SAVING is set and simply
> evaluate what the current device state is when pending_bytes is read.

It is the same as what you said: "initializes the migration region
data window" 

> > + SAVING | RUNNING
> 
> If we're trying to model typical usage scenarios, it's confusing that
> we started with SAVING and jumped back to (SAVING | RUNNING).

This section isn't about usage scenarios this is talking about what
the driver must do in all the state combinations. SAVING is
"initializing the data window"

And then the two variations of RUNNING have their own special behaviors.

> > +   This allows the device to implement a dirty log for its internal state.
> > +   During this state the data window should present the device state being
> > +   logged and during SAVING | !RUNNING the data window should transfer the
> > +   dirtied state and conclude the migration data.
> 
> As we discussed in the previous revision, invariant data could also
> reasonably be included here.  We're again sort of pushing an
> implementation agenda, but the more useful thing to include here would
> be to say something about how drivers and devices should attempt to
> support any bulk data in this pre-copy phase in order to allow
> userspace to perform a migration with minimal actual time in the next
> state.

Invarient data is implicitly already "device state being logged" - the
log is always 'no change'

> > +   The state is only concerned with internal device state. External DMAs are
> > +   covered by the separate DIRTY_TRACKING function.
> > +
> > + SAVING | !RUNNING
> 
> And this means we set SAVING and cleared RUNNING, and only those bits
> or independent of other bits?  Give your reader a chance to follow
> along even if you do expect them to read it a few times for it all to
> sink in.

None of this is about set or cleared, where did you get that? The top
paragph said: "requests a new device_state" - that means only the new
device_state value matters, the change to get there is irrelevant.

> > +   If the migration data is invalid then the ERROR state must be set.
> 
> I don't know why we're specifying this, it's at the driver discretion
> to use the ERROR state, but we tend to suggest it for irrecoverable
> errors.  Maybe any such error here could be considered irrecoverable,
> or maybe the last data segment was missing and once it's added we can
> continue.

This was an explicit statement that seems to contridict what you wrote
in the header. I prefer we are deterministic, if the RESUME fails then
go to ERROR, always. Devices do not have the choice to do something
else.

> > + ERROR
> > +   The behavior of the device is largely undefined. The device must be
> > +   recovered by issuing VFIO_DEVICE_RESET or closing the device file
> > +   descriptor.
> > +
> > +   However, devices supporting NDMA must behave as though NDMA is asserted
> > +   during ERROR to avoid corrupting other devices or a VM during a failed
> > +   migration.
> 
> As clarified in the uAPI, we chose the invalid state that we did as the
> error state specifically because of the !RUNNING value.  Migration
> drivers should honor that, therefore NDMA in ERROR state is irrelevant.

This is another explict statement that you have contridicted in the
header. I'm not sure mlx5 can implement this. Certainly, it becomes
very hard if we continue to support precedence.

Unwinding an error during a multi-bit sequence and guaranteeing that
we can somehow make it back to !RUNNING is far very complex. Several
error scenarios mean the driver has lost control of the device.

I'm not even sure we can do the !NDMA I wrote, in hindsight I don't
think we checked that enough. Yishai noticed all the error unwinding
was broken in mlx5 for precedence cases after I wrote this.

> > +  NDMA is made optional to support simple HW implementations that either just
> > +  cannot do NDMA, or cannot do NDMA without a performance cost. NDMA is only
> > +  necessary for special features like P2P and PRI, so devices can omit it in
> > +  exchange for limitations on the guest.
> 
> Maybe we can emphasize this a little more as it's potentially pretty
> significant.  Developers should not just think of their own device in
> isolation, but their device in the context of devices that may have
> performance, if not functional, restrictions with those limitations.

Ok

> > +
> > +- Devices that have their HW migration control MMIO registers inside the same
> > +  iommu_group as the VFIO device have some special considerations. In this
> > +  case a driver will be operating HW registers from kernel space that are also
> > +  subjected to userspace controlled DMA due to the iommu_group.
> > +
> > +  This immediately raises a security concern as user-space can use Peer to
> > +  Peer DMA to manipulate these migration control registers concurrently with
> > +  any kernel actions.
> > +
> > +  A device driver operating such a device must ensure that kernel integrity
> > +  cannot be broken by hostile user space operating the migration MMIO
> > +  registers via peer to peer, at any point in the sequence. Further the kernel
> > +  cannot use DMA to transfer any migration data.
> > +
> > +  However, as discussed above in the "Device Peer to Peer DMA" section, it can
> > +  assume quiet MMIO as a condition to have a successful and uncorrupted
> > +  migration.
> > +
> > +To elaborate details on the reference flows, they assume the following details
> > +about the external behaviors:
> > +
> > + !VCPU_RUNNING
> > +   User-space must not generate dirty pages or issue MMIO, PIO or equivalent
> > +   operations to devices.  For a VMM this would typically be controlled by
> > +   KVM.
> > +
> > + DIRTY_TRACKING
> > +   Clear the DMA log and start DMA logging
> > +
> > +   DMA logs should be readable with an "atomic test and clear" to allow
> > +   continuous non-disruptive sampling of the log.
> > +
> > +   This is controlled by VFIO_IOMMU_DIRTY_PAGES_FLAG_START on the container
> > +   fd.
> > +
> > + !DIRTY_TRACKING
> > +   Freeze the DMA log, stop tracking and allow user-space to read it.
> > +
> > +   If user-space is going to have any use of the dirty log it must ensure that
> > +   all DMA is suspended before clearing DIRTY_TRACKING, for instance by using
> > +   NDMA or !RUNNING on all VFIO devices.
> 
> Minimally there should be reference markers to direct to these
> definitions before they were thrown at the reader in the beginning, but
> better yet would be to adjust the flow to make them unnecessary.

The first draft was orderd like this, Connie felt that was confusing,
so it was moved to the end :)

> > +TDB - discoverable feature flag for NDMA
> 
> Updated in the uAPI spec.  Thanks,

It matches what Yishai did

Jason
