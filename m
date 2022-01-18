Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 439E2492FD7
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 22:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349465AbiARVA4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 16:00:56 -0500
Received: from mail-mw2nam12on2045.outbound.protection.outlook.com ([40.107.244.45]:14980
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1346040AbiARVAv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 16:00:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FG0OzTir9uHYQ+NNmnjukIuumd1kUscKG8Yak+7dNf/9cOwThvs7FRZ3n3uhfvjtVF5UDxWDOTwetaGFlqbjv5qHSzVAbAaXuo1r/4xiNa7YvVQOkDQFjtlTKCQ4pkfDqwsW4AV9UKDB2AVxGIvP5GCG1lgyLRCWJ9Zbj4Dv47J9cEnmNE4Sab/iTFBSztU9/jyLnEm5fLRby8Dx4ZoD85x7eWxkbpEgaOE8lVnYvDfsp6yJgg+/HuLpIj9X8z2EAaXBBjFVVIMxnzFST62ybr7ycYuk41O7FCEmwij5k9Gxm6FhK/PrPP6ZzDigw0CNCugi0o1RfrKztNWvzhfFGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AWxNltS4s37tfy5LiUo0GitCYN8NspI22bKB072BwII=;
 b=S6Tc3AaFGiGWIOXD9ov3k540nRZLXeWefkLe70UGxZEugW9etCSk+Xxk/jGzIeI6Zbv2WOJvtXhP7JQUBYU2N8TFiukGMZNWfoKEddG1kOiCFwoFIfS4s6pCNaEY0WG56s6SNLGjEzlvph58u04VVw7KYjCuMUG54/FFJoVguTGVff+VYioAgCx4m7In6E4hOg08GkKXeCXnMQlwAkAY9031rumRVu5cFr2EdbU5TdYXrbiG4Yxga4lSan9ozpnmMAcq2XQwd0zMlI8ghs9r5IM5ZU11EK3HVx3cOJOaLLTWXXRTSsy9NAMIvDT8yP0X4Bh6dH4sN2X5UkuFMNEXRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AWxNltS4s37tfy5LiUo0GitCYN8NspI22bKB072BwII=;
 b=AB4owCpp00rvowVp3wfqAU6ebJ/kZB/YYZsKul4fzsc6yRdx9JDxvHXaalpwpw9jpfwooAM568CSUG8+33BlKuURLVIQvgpguAd3+iFpEb2t89F505zZOSvP1n/cnzlBFRiNX7KcNs/ZB7cA16+tPEuMAYHlUgaTdV8H6aezrwmCdlDtSldVtahNHWJadliOA4BraEuvLzqcyZHRwJqffo66kSu7tjn61+7+vAxHTUQAItUfjdTKbht6F/Ocl9xTzOLMN/IB1xzw70DNimS1VPgK1MDKS3kRwu1DUCgY/CfjAHHvnxDnizmOR+qkJ7WBYSuW4aPb0sHGbOcwuVR5iQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BN6PR12MB1859.namprd12.prod.outlook.com (2603:10b6:404:ff::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Tue, 18 Jan
 2022 21:00:49 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af%8]) with mapi id 15.20.4909.007; Tue, 18 Jan 2022
 21:00:49 +0000
Date:   Tue, 18 Jan 2022 17:00:48 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC] vfio: Revise and update the migration uAPI
 description
Message-ID: <20220118210048.GG84788@nvidia.com>
References: <0-v1-a4f7cab64938+3f-vfio_mig_states_jgg@nvidia.com>
 <20220118125522.6c6bb1bb.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220118125522.6c6bb1bb.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1PR13CA0170.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::25) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0145f335-2023-4e06-567b-08d9dac59ae0
X-MS-TrafficTypeDiagnostic: BN6PR12MB1859:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB18595F31DAFFA6F947EC164AC2589@BN6PR12MB1859.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ja5bFPKzQHsZlt/GM9z/801e6m00sBw3Nuo0FzNdiDld/1x4yVAHgE7KaY0Ydj3XgYAycV3FV7NvzsxQZBu9sG7SFbZXRxq+06LRhYrEpchaK7AuqC8ug2OLRGLilNkrWDwRckCGCqAhSFaoLEzNGWoARYcXY6MCz2TetEl4F3EjeHsSLOUruVp0eZDnoonHGBll9BwRW74qtsAT/ld0HsfNa9P06GqcCB5b+Pj5VWxvZzm+v1pvcQuPsm5qaCEoMVvnKiutl0tEOHxW0HGpAtgUI19tHDWvCPNi6QEejSasGOc3Ckj6G9AWo2GqGuh3TohRmO3UH+Sc5nIuIQEfoUeaSS1Ctaj2IMU4OefRqF1ZAszmjaV5iS8czR62VeHefEVj82OXdvoTx3ZYriMaKXQJxg2n1spH7J0UGa4R4trgcPzNgzp5ZbIHbQFu0UYBRZ3hbPD+wHvGNA75ReIf/mTC2HCVAeCLX6eSieykPtXUfTZWuNfaNvAxp85KRYrqknGUoBB9WGQBvwcrShN2uFuGjPmF6bTsDbCow4xAkSm+9oUJPADJ0djO39NI7+51KuZd5gdKAZn6/b/y6rewjNrQF6Eyzyuw/KTzf2JaSSUBJLba0DEGq7aWkwsqmuhmgUAWvIcQ8/G7oTzWj4z52Y7oYa2HU8fk5yHA/+maCbJ7606XyIZV4NwW5V5d2chjm8XyBcny1UXCKM80zi1Pi8jS1D84P1nN0CgnL+pM7ZgZcmxSllz/bRaSaol7GcUhnY0bv4OR/Gx7jWk+yZAzzQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(6512007)(316002)(66556008)(66476007)(6506007)(33656002)(8936002)(6486002)(508600001)(966005)(5660300002)(4326008)(186003)(2616005)(1076003)(6916009)(86362001)(26005)(54906003)(36756003)(83380400001)(66946007)(107886003)(38100700002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dNDQeA9xq3FqbkeHXCrBuS1qp3yE0QBbXLmOf5vHkqO6lUpdUYpGFGWeoaEy?=
 =?us-ascii?Q?7u9eCNVMjuaZZDxRouuO4YCJgjgxBCY0QZe4ZVp1Gx+qqU2dU1FOI5n0kcza?=
 =?us-ascii?Q?Qn8IBX+kvF9ONkZTM/x59yb1L3ZPUxQ99IOMopqgqnvbzyk7/HLeO1iFBROP?=
 =?us-ascii?Q?HmHZtZJDfWONORvbRjbzxqEoTYd252bB7NTOl6v6zgqzpKvNMcWU5OGqu5Zg?=
 =?us-ascii?Q?d5x1aYtv9XZNx6RSgbCUf+xkV37CVCbZeVqfzafgGQ6dkUQLlwWLZT96x/8i?=
 =?us-ascii?Q?ILBF9olbw/vGiAtkNJ9stiY8c7H6BfHS0qRBnL+NVNR2a1Sx++4gM+/lU9XP?=
 =?us-ascii?Q?qFwsiX3kRqV7SpEtClGL/8ofs5bp1+N29qMog1mqXDgdnTqrpQfXh04rWjgp?=
 =?us-ascii?Q?idrjUQgynxNgsGIzrk7kRYp5OMt60r8EPoRHjXm8EYlalvAuiVAqJqWTgKUo?=
 =?us-ascii?Q?EKz/rEL1I1vnUmuR/68R/IHlZck8MxG1x7tagyEsmwLgnXQkeHh0DQfpDFC2?=
 =?us-ascii?Q?DbJoDugaugQG+hupShlEWusakOIGusMibe0Fx8ykujmsoYXXPPlc/mRBA+jk?=
 =?us-ascii?Q?D3rIcvdxecZz7UzOLNU06PENxzHthrxbzIZbLIcVoY/Deby6fMe/FiMwlZ5z?=
 =?us-ascii?Q?n69H2FJ/2XpgXgINNni+YjdeFOtXpzhtTZFLTtc8dwuVXSmvfwSOlps1QyZU?=
 =?us-ascii?Q?THx9Cny/7uS/YlmhCz/o9rQ3Faox2OWFuJqkBu3HWLaYInn+Kg7cbJH9fuwt?=
 =?us-ascii?Q?vJrw7QfxC/OgMRlRVRnd/UncXprGe6OjZ/3ZxjgGP0x2EZDlfi4E7Wr5Zljp?=
 =?us-ascii?Q?RIYWplgBbu++LaER3n1t8rqUFu63CkX+luoPfH4POYrLvGLc+Olipn4e6QGd?=
 =?us-ascii?Q?f9bnbhIdFAHzcf+uQdpiViYI4WQEIzpcG3LI3E7I0ubK4zWO7FVvoUNZhf9v?=
 =?us-ascii?Q?l20d5wuBfxL149047VQl49qG3szcl0U4+8I4yYh4ldLtapXQR1l5YYE2TFpv?=
 =?us-ascii?Q?7dRkM+fDDNWMivHt7nx84QBmWl/iyMG3D0C9bMAF6zYv5j/jdu41aIDJQdkx?=
 =?us-ascii?Q?8yn973jZJkpFUfHms1IPT4EZZxwuHFFfYNBgYhiRAVKPI3UG9QLhRwAzBSiB?=
 =?us-ascii?Q?04+hPDK4E7T03ChTMF4NnvS2RNkglxAiwf+1TVZwiu0n40BMUORe4OoTiYJr?=
 =?us-ascii?Q?yj1ETV1bZMafZmKKOs4gUxfWMQ0LcB2o0+y1zxsGHKxU5H/1J+ahw1a2eLku?=
 =?us-ascii?Q?7HO2F6ae0MiXf8gbqQfLv7SL95bBJGjIVl4o0a1GWoai2Pf96nQvztJlsQtv?=
 =?us-ascii?Q?RmjSNWQOp3ig2dH4DCG3eXcRYHYVg3YJf+5GWuV0MyN1ZB4Sd1A7jEE5joF0?=
 =?us-ascii?Q?xdDkP6kQgEzZkOiVjVF3jeMwAHp49AaOVBZB/ZiDlvqmuS07q3239Ap8fudF?=
 =?us-ascii?Q?2+WkJjmgt7BV5u1y0zwMpIgYdlEWM9AsRNdfX5hi3YVNAT95m6nNQsvJghYP?=
 =?us-ascii?Q?ERSk/x4zINwxdIDb4E/QXU3GUfMEQdvgOt4nkKy6DLlJLw6uSn/NtrE/HsoW?=
 =?us-ascii?Q?jV7iUg3OKn9JJDW2bg8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0145f335-2023-4e06-567b-08d9dac59ae0
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2022 21:00:49.3627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QrBOGwsgFu0nXNKwEczNATvf70M3A8cEpX6j55rmi45EB3TH59HgstRWnaxubjgI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1859
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 18, 2022 at 12:55:22PM -0700, Alex Williamson wrote:
> On Fri, 14 Jan 2022 15:35:14 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > Clarify how the migration API works by recasting its specification from a
> > bunch of bits into a formal FSM. This describes the same functional
> > outcome, with no practical ABI change.
> 
> I don't understand why we're so reluctant to drop the previous
> specification and call this v2. 

I won't object - but I can't say it is really necessary.

> Yes, it's clever that the enum for the FSM matches the bit
> definitions, but we're also inserting previously invalid states as a
> standard part of the device flow... (see below)

This is completely invisible to userspace, if userspace never writes
the new states to device_state it can never read them back.

> > This is RFC because the full series is not fully tested yet, that should be
> > done next week. The series can be previewed here:
> > 
> >   https://github.com/jgunthorpe/linux/commits/mlx5_vfio_pci
> > 
> > The mlx5 implementation of the state change:
> > 
> >   https://github.com/jgunthorpe/linux/blob/0a6416da226fe8ee888aa8026f1e363698e137a8/drivers/vfio/pci/mlx5/main.c#L264
> > 
> > Has turned out very clean. Compare this to the v5 version, which is full of
> > subtle bugs:
> > 
> >   https://lore.kernel.org/kvm/20211027095658.144468-12-yishaih@nvidia.com/
> > 
> > This patch adds the VFIO_DEVICE_MIG_ARC_SUPPORTED ioctl:
> > 
> >   https://github.com/jgunthorpe/linux/commit/c92eff6c2afd1ecc9ed5c67a1f81c7f270f6e940
> > 
> > And this shows how the Huawei driver should opt out of P2P arcs:
> > 
> >   https://github.com/jgunthorpe/linux/commit/dd2571c481d27546a33ff4583ce8ad49847fe300
> 
> We've been bitten several times by device support that didn't come to
> be in this whole vfio migration effort.

Which is why this patch is for Huawei not mlx5..

> At some point later hns support is ready, it supports the migration
> region, but migration fails with all existing userspace written to the
> below spec.  I can't imagine that a device advertising migration, but it
> being essentially guaranteed to fail is a viable condition and we can't
> retroactively add this proposed ioctl to existing userspace binaries.
> I think our recourse here would be to rev the migration sub-type again
> so that userspace that doesn't know about devices that lack P2P won't
> enable migration support.

Global versions are rarely a good idea. What happens if we have three
optional things, what do you set the version to in order to get
maximum compatibility?

For the scenario you describe it is much better for qemu to call
VFIO_DEVICE_MIG_ARC_SUPPORTED on every single transition it intends to
use when it first opens the device. If any fail then it can deem the
device as having some future ABI and refuse to use it with migration.

> So I think this ends up being a poor example of how to extend the uAPI.
> An opt-out for part of the base specification is hard, it's much easier
> to opt-in P2P as a feature.

I'm not sure I understand this 'base specification'. 

My remark was how we took current qemu as an ABI added P2P to the
specification and defined it in a way that is naturally backwards
compatible and is still well specified.

> > +enum {
> > +	VFIO_MIG_FSM_MAX_STATE = VFIO_DEVICE_STATE_RUNNING_P2P + 1,
> > +};
> 
> We have existing examples of using VFIO_foo_NUM_bar in the vfio uAPI
> already, let's follow that lead.

OK
 
> > +/*
> > + * vfio_mig_get_next_state - Compute the next step in the FSM
> > + * @cur_fsm - The current state the device is in
> > + * @new_fsm - The target state to reach
> > + *
> > + * Return the next step in the state progression between cur_fsm and
> > + * new_fsm. This breaks down requests for complex transitions into
> > + * smaller steps and returns the next step to get to new_fsm. The
> > + * function may need to be called up to four times before reaching new_fsm.
> > + *
> > + * VFIO_DEVICE_STATE_ERROR is returned if the state transition is not allowed.
> > + */
> > +static u32 vfio_mig_get_next_state(u32 cur_fsm, u32 new_fsm)
> 
> Can we use a typedef somewhere for type checking?

An earlier draft of this used a typed enum, lets go back to that
then. It just seemed odd because the uapi struct comes in as u32 and
at some point it has to get casted to the enum.

> > +	/*
> > +	 * Make a best effort to restore things back to where we started.
> > +	 */
> > +	while (*cur_state != starting_state) {
> > +		next_state =
> > +			vfio_mig_get_next_state(*cur_state, starting_state);
> > +		if (next_state == VFIO_DEVICE_STATE_ERROR ||
> > +		    device->ops->migration_step_device_state(device,
> > +							     next_state)) {
> > +			*cur_state = VFIO_DEVICE_STATE_ERROR;
> > +			break;
> > +		}
> > +		*cur_state = next_state;
> > +	}
> 
> Core code "transitioning" the device to ERROR seems a little suspect
> here.  I guess you're imagining that driver code calling this with an
> pointer to internal state that it also tests on a non-zero return.

Unfortunately, ideally the migration state would be stored in struct
vfio_device, and ideally the way to transition states would be a core
ioctl, not a region thingy.

If it was an ioctl then I'd return a 'needs reset' and exact current
device state.

> Should we just step-device-state to ERROR to directly inform the driver?

That is certainly a valid choice, it may eliminate the very ugly
pointer argument too. I will try it out.

> > + *   RUNNING_P2P -> STOP
> > + *   STOP_COPY -> STOP
> > + *     While in STOP the device must stop the operation of the device.  The
> > + *     device must not generate interrupts, DMA, or advance its internal
> > + *     state. When stopped the device and kernel migration driver must accept
> > + *     and respond to interaction to support external subsystems in the
> > + *     STOP state, for example PCI MSI-X and PCI config pace. Failure by
> > + *     the user to restrict device access while in STOP must not result in
> > + *     error conditions outside the user context (ex. host system faults).
> > + *
> > + *     The STOP_COPY arc will close the data window.
> 
> These data window "sessions" should probably be described as a concept
> first.

Er, OK.. I think it is all well described now, your new data window
language is much clearer, but lets try a small paragraph at the start
linking the data window to the FSM..

> > + *   RESUMING -> STOP
> > + *     Leaving RESUMING closes the migration region data window and indicates
> > + *     the end of a resuming session for the device.  The kernel migration
> > + *     driver should complete the incorporation of data written to the
> > + *     migration data window into the device internal state and perform final
> > + *     validity and consistency checking of the new device state.  If the user
> > + *     provided data is found to be incomplete, inconsistent, or otherwise
> > + *     invalid, the migration driver must indicate a write(2) error and
> > + *     optionally go to the ERROR state as described below. The data window
> > + *     is closed.
> > + *
> > + *     While in STOP the device has the same behavior as other STOP states
> > + *     described above.
> 
> There is one STOP state, invariant of how the device arrives to it.

In FSM theory we have the idea of Moore and Mealy FSM designs, this
description is following Mealy principles because that best fits the
actual driver implementation.

Paraphrashed, the distinction is that Moore is strictly about the
current state, while Mealy considers the arc by witch the state was
reached.

What I expect is that the device will exhibit a Moore kind of behavior
- eg STOP is STOP, but the driver implementation must be fully
Mealy. Look at how mlx5 is setup, each and every test is looking at an
arc.

This is because the arc encodes important information,
PRE_COPY -> RUNNING has a very different driver implementation than
RUNNING_P2P -> RUNNING even though they both end up in RUNNING.

Yes, the device should exhibit the same continuous behavior while in
the RUNNING state, but we can still describe that behavior by only
documenting arcs.

If you recall I tried to mix Moore and Mealy descriptions in my last
effort and everyone thought that was really confusing, I don't think
this will fare any better.

In this case, RESUMING -> STOP is different than any other way to
reach STOP, and it does trigger special driver behavior that needed a
paragraph to describe. The difference only exists while executing this
arc, and then STOP is STOP.

I think sticking to one FSM style for the documentation is the right
answer here. How about instead of just listing the states at the very
start we have short list with a one line summary of the state?

> The reader can infer from the above statement that the behavior of a
> state may be flexible to how the device arrives at the state unless
> otherwise specified.

There are two different things, the continuous behavior while in a
state, which is not flexible, and the actions the device takes, which
is. Go back to my last document to see how this looks when we try to
split them and spell them out separately.

Anyhow, it seems you are fine with the approach. Yishai can make the
changes you noted and lets go forward next week.

Thanks,
Jason
