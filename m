Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B051749C0C9
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 02:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235883AbiAZBdD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 20:33:03 -0500
Received: from mail-dm6nam11on2064.outbound.protection.outlook.com ([40.107.223.64]:57952
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235884AbiAZBdB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 20:33:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EAsBf4n2bw6pB+ECGyinwW9IXQ04zgprU0RKZaeomrfqCUYCTY9KJIvJpTLjO+5T+6VQPodsib6w+ewdC0S6DUhoOtHzAIOB18STxe33Tkru8VlqIlTCqxxnTmYUI+zk7KQg9Lfeiq46Q5O9fUWZnHxnVTgVig3yzg3MOca9Euu/wGuIeQUpqreJVJgHNkIEkBAoV94GKH2pM5t9gZvm7yXaIqgLmyvq0YikLE276d+hTYkgxxnVPz6uSPlyWdLN2PAirtxqE6cZ6Y+rK3FhAersBTI8pR/ltrsJvoYLP7ptjms7LRHpY/5IF4Z5NOISmHrjiPMTHBE2KjPvBP104w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=izznohDzkzbniSn0NyWmr8iQUOaQKiBYXAnsu11O4pw=;
 b=hNo3y6kdVfYlfVNg58+EFfHx1+pqgpZeCdyL4r0oTaobB3POjqrQc5ym++t0UBvGA0OEgvUjExAXu8QpujaW71jcxZUHSavgxhNNZhcRHUI/kBCzouwvSyVoPJwDbEnyWrPweMkc63ApsDivui6zkZiKai4inOWHH03aj2nsdM+fjs3ParXM4tL4LmdxMHbeLbA7vM9xAu+6MAPt8tPDOY+gVIVHQROrEqrpzlr6Pv0I+EHS5zamVJu5p92dVfjMZJ/C2Wo20suTrGksS8mvLAnjIT/X9ukNXge/QJ1nBQA2EjXXmbRgC7CE0miConK5vyEGuzjheJgFDhI3OGbVKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=izznohDzkzbniSn0NyWmr8iQUOaQKiBYXAnsu11O4pw=;
 b=LAUhsUf+Cm5WofziMz1EynVf//Mdu7LOZxWKz7f4IPNw9Kc5nHKlZj6AyC0gmbliyOP2Ax0BRInqIxMnEbx9asKP8XBB7PBNGtLvCAAlTA1RAwDbKxEu3HVBHDKWUF2qTaZahtY1VCvLPpD1PNYAiuhZvXA4fxZGiwV4YWiWAQP3Sat2LfnynGtGyQ1QJ5cAfmbAksZ8F+1CTJOwc2+DX2+8rkGbFpEaDPf/O1D22iIB3FhkxoXYenXp2dqKqiUJHT4Bf4HzB7N8J1kCLujjrEbBW8qzRv+8+rq7lPYvcbZD+bOJK8c7hkl3Elch3EgG3swu49bNzIRx5/QxyxGR8g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH2PR12MB4181.namprd12.prod.outlook.com (2603:10b6:610:a8::16)
 by CH2PR12MB4134.namprd12.prod.outlook.com (2603:10b6:610:a7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Wed, 26 Jan
 2022 01:33:00 +0000
Received: from CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::6118:6128:bd88:af7a]) by CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::6118:6128:bd88:af7a%6]) with mapi id 15.20.4909.017; Wed, 26 Jan 2022
 01:33:00 +0000
Date:   Tue, 25 Jan 2022 21:32:58 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC] vfio: Revise and update the migration uAPI
 description
Message-ID: <20220126013258.GN84788@nvidia.com>
References: <0-v1-a4f7cab64938+3f-vfio_mig_states_jgg@nvidia.com>
 <BN9PR11MB5276BD5DB1F51694501849568C5F9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220125131158.GJ84788@nvidia.com>
 <BN9PR11MB5276AFC1BDE4B4D9634947C28C209@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276AFC1BDE4B4D9634947C28C209@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR11CA0009.namprd11.prod.outlook.com
 (2603:10b6:208:23b::14) To CH2PR12MB4181.namprd12.prod.outlook.com
 (2603:10b6:610:a8::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eea42673-e72e-4f44-4a09-08d9e06bc989
X-MS-TrafficTypeDiagnostic: CH2PR12MB4134:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB413428BE9989C45244B0CD41C2209@CH2PR12MB4134.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7+hQxtNjBsyhvnxZGCunrYHPqKCm5JcVfH1Rblt/6M69sljFN39fwXiVaNyIsVpzeYzLLnorZeRavKiWIzSsvCcneaqM8L/NMDE0a4ow9FJcEJaVTRyZNC73Mi6PtJVlLVr/Jzdq9L1gjvCh+rOWphl7l6pncZEnkrb1AtIhrtEwmGX2oF3cP3pWPTJcM9UWxci4+thGS8fKXEUxxz3r8OhW/neDtZuTztdbXSf5bzQPK5Jwrtw+qFGxaaN2CcZLcUBxRlPHNxYxSul4ZIX9aRaFtUlmQZf/5TBj2oTTp3aOHGMH5BmiRHaLx0WnT9gb/rJ+r6ciPEniinYnWS31qx1Bmi57Dwf1AqMGDD8gt12R71SqzH/kr6ayyjAddOlt0v15L4iWjBMwc4viw0hkrb22+BHDmWXolR0bqHomzaFnbot0wC8TMp7/0sZSEEty6UbJfdUWuh4AgHAtJbSjjiIiiH9kWlz5Ej1r3FUkv+I9K6nS2cHKiF3katVhKTdbd3242+CBlCZ4vK4HssV3/srq/F51NKH92UReC6bmOGGTWrJEsg8kUNET2ziWY0YG8DYEBNk/644YbtId5yzA19dYXp7D77A1JUDN0ZPepS0hsnBiHQIQoA4g2WvauTg8/AsevbBf54h7gnCKSFOW4A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4181.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(1076003)(2616005)(83380400001)(86362001)(4326008)(33656002)(6506007)(6512007)(107886003)(26005)(6486002)(186003)(36756003)(6916009)(316002)(38100700002)(5660300002)(54906003)(66476007)(8936002)(8676002)(66556008)(66946007)(2906002)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1GZmFT1l1/E0FGAL9ckuninlqfZlBXMKgKqwvy8xRytoh8zF9DQTQxC9Plm5?=
 =?us-ascii?Q?DPEx29Ouxt/4HUZYx1Nm5fgfdpgkuYcPrn4ZiObt2+ZVqfVANEViKEOU2vOi?=
 =?us-ascii?Q?P7ijFjkXcB4Os7b8Uo6jIX6XGVu+W4wb9BeRphk9kl1juitkjHD7Kq0Fc6Ns?=
 =?us-ascii?Q?rJ6REOzy4vU3664hvRAuEZKiCmic3C3o2E5kLKmAkFoHzFA0mVQX0TnE46CW?=
 =?us-ascii?Q?wvPaqORmqPdNWJGMDtKMQX4YNogekqhTGCwHji3tShLWscECUGFx4gtFSJuJ?=
 =?us-ascii?Q?XDoO395A9xvAsDRezMgeyIV08Bft53YN1QRTuTHe63mOTSRPyib9puQX1T/D?=
 =?us-ascii?Q?S8aoUKjiIqjk2Kc2mYlZoh8ca1pymPsq9v0xKWL19SmZPv3NWOQHPuxArIKf?=
 =?us-ascii?Q?aZQ92nLdR7hHte9MHU7Wp6vIWX+WXtZUG8Qhf4Y3F1LhFVke0fM0i55VXjLY?=
 =?us-ascii?Q?D/K+rF0NfpfT4DzVV6T6CbBab5Sxgm5DhUIeL0WNg1QaARyVoc88D6keqHTE?=
 =?us-ascii?Q?YKARsEf5a3Sv8KDBl9ixf5USCKrXYMp+TFaZX7ZKCHf64bYMYRJbnw5n6AmV?=
 =?us-ascii?Q?ojUAWVjSGru13UodBTCN4OLWhSvwtge0W7hgDG4A/QjfiZ3sKKF7261gzxg3?=
 =?us-ascii?Q?/TgWke/DGCpKhXK8HvhPeYDdBbVMfNmkWLACUeIfQGR+C760gmjUCOA9S8yN?=
 =?us-ascii?Q?Ana3C/PQcFtFa6mUTTi+ueTpjV7WquwZ5ew4kw9sJ/L/oYetLYp5dwJsITQ0?=
 =?us-ascii?Q?+ej5KfQeFin1FhIeZ7zzfyvxVedtEA8A4+w035BvcVwAnHeNmTMQ6oaiA3QK?=
 =?us-ascii?Q?rBKpWA96KdLX0VmNiDrBh8I2Bsvt4bzwPUI5jrNxuYblB2GTzJIT8PsKefmA?=
 =?us-ascii?Q?+3KB1hEox/1Hiz9qCExtSkn//6GC+zwNrADZBkEinxvN3uhC1gj5hjc1NJTs?=
 =?us-ascii?Q?pd083v8ipG9V2VyLuz5GzWsWb3qDcsz6S4MmduV8gRKuL8+o4rP/YwnYhq9m?=
 =?us-ascii?Q?I7quw/ENHMBJjAQ9C1tDZHuf5BGOMWVFoMnUL4QAsYlVeNzpFIj/rnGqX2dm?=
 =?us-ascii?Q?Nc867vpc4soMbdEspTKVZKyXbt69HnZkWlyFgcQuXSlKr5WV1PjSxt3cfJrW?=
 =?us-ascii?Q?yHeAB1Q9fggsIgFrOEeXMW3hPDnhvTpGhLkEbD4RIX3uQRTaNlVyNltOnS62?=
 =?us-ascii?Q?Juv9YPBw0iz0OkUOdDZWfhMWFhAiNuTcfZCdN2Iab3jvehSZSwqzv6RZaxzO?=
 =?us-ascii?Q?RNXsjlEjAEHiGMrH1vSRqElHvR2BSXG+5p76aYYJ7Ysf/+al6nwbH8BMjJRE?=
 =?us-ascii?Q?PIUrhhruHwiYEiAv5iixl5MublcKhgyx2OaeqdxKVNhB6fXHvSECahNGEfHo?=
 =?us-ascii?Q?s6rC3RW9pE/Ngoofa4unAkFTcgtESpaMuYBSHo5uBMYtkvdBdWHWNMKpA0s9?=
 =?us-ascii?Q?qU3C/1AVMKJFTsaGtqxDnanCeiYYb0wIAGxcj9aLhjU08vcCU5BN7EEEPqoA?=
 =?us-ascii?Q?4E+pghu5/pbqD5YnDeJZ+iIhLIhn1QGzGIo/PaHkN+sUe6vxlnMekpKL7vCZ?=
 =?us-ascii?Q?rWkERyelmJa15HONPgY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eea42673-e72e-4f44-4a09-08d9e06bc989
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4181.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2022 01:32:59.9308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ig0lyj+VYVZWtUxMlcoAm/H5jnNZ7H/0k9+nohfO+zYfM2vs0cxol+xieTpbRjwH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4134
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 26, 2022 at 01:17:26AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Tuesday, January 25, 2022 9:12 PM
> > 
> > On Tue, Jan 25, 2022 at 03:55:31AM +0000, Tian, Kevin wrote:
> > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > Sent: Saturday, January 15, 2022 3:35 AM
> > > > + *
> > > > + *   The peer to peer (P2P) quiescent state is intended to be a quiescent
> > > > + *   state for the device for the purposes of managing multiple devices
> > > > within
> > > > + *   a user context where peer-to-peer DMA between devices may be
> > active.
> > > > The
> > > > + *   PRE_COPY_P2P and RUNNING_P2P states must prevent the device
> > from
> > > > + *   initiating any new P2P DMA transactions. If the device can identify
> > P2P
> > > > + *   transactions then it can stop only P2P DMA, otherwise it must stop
> > all
> > > > + *   DMA.  The migration driver must complete any such outstanding
> > > > operations
> > > > + *   prior to completing the FSM arc into either P2P state.
> > > > + *
> > >
> > > Now NDMA is renamed to P2P... but we did discuss the potential
> > > usage of using this state on devices which cannot stop DMA quickly
> > > thus needs to drain pending page requests which further requires
> > > running vCPUs if the fault is on guest I/O page table.
> > 
> > I think this needs to be fleshed out more before we can add it,
> > ideally along with a driver and some qemu implementation
> 
> Yes. We have internal implementation but it has to be cleaned up
> based on this new proposal.
> 
> > 
> > It looks like the qemu part for this will not be so easy..
> > 
> 
> My point is that we know that usage in the radar (though it needs more
> discussion with real example) then does it make sense to make the 
> current name more general? I'm not sure how many devices can figure
> out P2P from normal DMAs. If most devices have to stop all DMAs to
> meet the requirement, calling it a name about stopping all DMAs doesn't
> hurt the current P2P requirement and is more extensible to cover other
> stop-dma requirements.

Except you are not talking about stopping all DMAs, you are talking
about a state that might hang indefinately waiting for a vPRI to
complete

In my mind this is completely different, and may motivate another
state in the graph

  PRE_COPY -> PRE_COPY_STOP_PRI -> PRE_COPY_STOP_P2P -> STOP_COPY

As STOP_PRI can be defined as halting any new PRIs and always return
immediately.

STOP_P2P can hang if PRI's are open

This affords a pretty clean approach for userspace to conclude the
open PRIs or decide it has to give up the migration.

Theoretical future devices that can support aborting PRI would not use
this state and would have STOP_P2P as also being NO_PRI. On this
device userspace would somehow abort the PRIs when it reaches
STOP_COPY.

Or at least that is one possibility.

In any event, the v2 is built as Alex and Cornelia were suggesting
with a minimal base feature set and two optional extensions for P2P
and PRE_COPY. Adding a 3rd extension for vPRI is completely
reasonable.

Further, from what I can understand devices doing PRI are incompatible
with the base feature set anyhow, as they can not support a RUNNING ->
STOP_COPY transition without, minimally, completing all the open
vPRIs. As VMMs implementing the base protocol should stop the vCPU and
then move the device to STOP_COPY, it is inherently incompatible with
what you are proposing.

The new vPRI enabled protocol would have to superceed the base
protocol and eliminate implicit transitions through the VPRI
maintenance states as these are non-transparent.

It is all stuff we can do in the FSM model, but it all needs a careful
think and a FSM design.

(there is also the interesting question how to even detect this as
vPRI special cases should only even exist if the device was bound to a
PRI capable io page table, so a single device may or may not use this
depending, and at least right now things are assuming these flags are
static at device setup time, so hurm)

Jason
