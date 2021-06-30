Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D94013B7E0C
	for <lists+kvm@lfdr.de>; Wed, 30 Jun 2021 09:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232936AbhF3Hax (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Jun 2021 03:30:53 -0400
Received: from mail-he1eur01hn2224.outbound.protection.outlook.com ([52.100.5.224]:35655
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232881AbhF3Haw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Jun 2021 03:30:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=On/IyaYjSwFwfnogJv2gPT0Nt43UtDTo2b1lFPsawALj+WxQUYyqLBhp2N1kUm66J65aUuyZE7leBLGSfYExhVf1jJ07aZKlcbO7eoTNAgXtsjn1vIt3fWxCfIvBX+kHLphbCAH0ZIO5nNb++n/JVkBdLLZjCGfuaymK5roZY3X396CeCwhr/eg7pzpe/TbaFtn/vq/CZomOPU0JaCvHdy8UUmQpnEPiH3p+DbfXoh9PERrQ0FSBtm9l6EJ88dNxRMWyHlXdEllaRTEdUqgo9gS6gt7E7a8jKF6TucduYoJfAjHizEPiDzbH/wR6eSs/PdGqubsVGE0Aqg/kAERF+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u+KA6V5jpJ63K/8a6CWzGt5EUnqJf7ACvrTki0ooos4=;
 b=FtbpvdOPk2XQS9Pcn3knrHvuBpwBvmqgEPKPrMKDhEKnX3HMN51mf9TOxG2t9ecRZIW21SPHpaSoSuKwNxTCPhDdVtoZXLAVIg03ReRVTdaF1yv5h40Sn6rxD0X9D6MOryl92vqgpuAY4i8+3bUDJ+/OVLmMHDwJAnKRXLA/GzEaJ9pB1X/ESp+7Q71mRSMZuYuv+rYzstKFQ31ZqbwN6neaIpUT1JDH3xM/CLuxQZ0MSTNJbXaYBn4cGGhMQZyupsiFWPmYvV/zGiUkVTmawM6/z1e+9g3Dz/lhtdjC4ROi9JBwZ/AfcymbpLgz3mr+Z5yBpBhX8Sl8sg7BsYf5Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u+KA6V5jpJ63K/8a6CWzGt5EUnqJf7ACvrTki0ooos4=;
 b=E3AaiLEt4BLFFQ406f174mWGrFOpOPF5Cr0gvWuLEvvs7d5QhS3rEziqRWrM92pyQDt4hlNkhjJTHoV8oiKZB2ikJmrRmsJbnoZXgGLp2ki/VbY8u+J690KgNAc+s5jSZMZWRTVqKDkdNksSzPqrbHTFj6WXdi4q0Ww7zDORSNA=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=virtuozzo.com;
Received: from AM9PR08MB5988.eurprd08.prod.outlook.com (2603:10a6:20b:283::19)
 by AM9PR08MB6004.eurprd08.prod.outlook.com (2603:10a6:20b:285::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21; Wed, 30 Jun
 2021 07:28:14 +0000
Received: from AM9PR08MB5988.eurprd08.prod.outlook.com
 ([fe80::c6c:281b:77e6:81b6]) by AM9PR08MB5988.eurprd08.prod.outlook.com
 ([fe80::c6c:281b:77e6:81b6%6]) with mapi id 15.20.4242.023; Wed, 30 Jun 2021
 07:28:14 +0000
Date:   Wed, 30 Jun 2021 10:28:08 +0300
From:   Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>
To:     Markus Armbruster <armbru@redhat.com>
Cc:     Eduardo Habkost <ehabkost@redhat.com>,
        Claudio Fontana <cfontana@suse.de>,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel@nongnu.org, Denis Lunev <den@openvz.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Blake <eblake@redhat.com>
Subject: Re: [PATCH v9] qapi: introduce 'query-kvm-cpuid' action
Message-ID: <20210630072808.GA67573@dhcp-172-16-24-191.sw.ru>
References: <877dis1sue.fsf@dusky.pond.sub.org>
 <20210617153949.GA357@dhcp-172-16-24-191.sw.ru>
 <e69ea2b4-21cc-8203-ad2d-10a0f4ffe34a@suse.de>
 <20210617165111.eu3x2pvinpoedsqj@habkost.net>
 <87sg1fwwgg.fsf@dusky.pond.sub.org>
 <20210618204006.k6krwuz2lpxvb6uh@habkost.net>
 <6f644bbb-52ff-4d79-36bb-208c6b6c4eef@suse.de>
 <20210621142329.atlhrovqkblbjwgh@habkost.net>
 <874kdrkyhs.fsf@dusky.pond.sub.org>
 <20210621160951.GA686102@dhcp-172-16-24-191.sw.ru>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210621160951.GA686102@dhcp-172-16-24-191.sw.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [185.231.240.5]
X-ClientProxiedBy: PR2P264CA0003.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::15)
 To AM9PR08MB5988.eurprd08.prod.outlook.com (2603:10a6:20b:283::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dhcp-172-16-24-191.sw.ru (185.231.240.5) by PR2P264CA0003.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22 via Frontend Transport; Wed, 30 Jun 2021 07:28:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ed5e315b-7c7e-4c4d-1307-08d93b989f3c
X-MS-TrafficTypeDiagnostic: AM9PR08MB6004:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM9PR08MB600411A562BC684E725BA15F87019@AM9PR08MB6004.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:AM9PR08MB5988.eurprd08.prod.outlook.com;PTR:;CAT:OSPM;SFS:(4636009)(396003)(39840400004)(346002)(376002)(136003)(366004)(26005)(38100700002)(9686003)(38350700002)(5660300002)(6506007)(478600001)(53546011)(55016002)(83380400001)(66476007)(6666004)(66556008)(186003)(7416002)(66946007)(16526019)(36756003)(966005)(2906002)(7696005)(8936002)(44832011)(1076003)(54906003)(33656002)(8676002)(86362001)(956004)(52116002)(6916009)(4326008)(316002)(30126003);DIR:OUT;SFP:1501;
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?COdB/zZLfDBjfFX8w4Y3QApNErigkc6A9RQ8a5ORNo3Ji1+T/szgnIZXWcQO?=
 =?us-ascii?Q?XixvPjK0fZo0ffkgPeB9vVGzSQEVpG3LBqrO84BKZsw546gkSyQe9kE69djM?=
 =?us-ascii?Q?pQbxvRjkzUCRtO4fmdxYRN3bqCdkzrCQcA7AhjUSnQ50yZaufLeESq+OLg2L?=
 =?us-ascii?Q?2PlDjLP1UJ+d7HGmAO1KtNwiWZU9THaCDY4BlJKD4pMOnZ8jXA3lZhWFoOzF?=
 =?us-ascii?Q?ZOE7w3NnD1duGyqDa+x3/yXzbwje6WCocbXMfN2YXx/iOj8jrgHdnlrp1vMH?=
 =?us-ascii?Q?vNfFYC5aWfat4HqKoRHncEOR4yYHZbQXScwCVvoociDkz8hC/D+Sv/G7H2tx?=
 =?us-ascii?Q?4SUo2kEAu7lORiz7sVCXxrFnNNU6ze0t4MSpdx+0niWzL/r7/TiNvPu9VvXt?=
 =?us-ascii?Q?HWAdtPNBPJ7KWySz6K93Xhj84IqulrngKtx8gSstxWty/4Rj3HKXvTyAhmXZ?=
 =?us-ascii?Q?OMd0bLSDcuBE+RpGdaP5PyHus6JgKBweM3gf+L0B2Ajt5GrMOYNmhHNOs5e6?=
 =?us-ascii?Q?7R/5Egam2l/sZW6dT2IApkrKruEA/okzc/JrHUTLCx3piKfYRp4B11Hw17sm?=
 =?us-ascii?Q?/a4kzGUdtvvMuITG/9I+9huYwvcCPxpXDSA4GOIZApTYGlCCNPCTfTQvN8bR?=
 =?us-ascii?Q?MB9Yp6dM9xFRpa8acCB/ZkmcUfeApu98sLneGe9NsLTXp90m8sxUXCSEXE6T?=
 =?us-ascii?Q?I1aEFgw4DNjJB/FHXHlzUIxOB/MlHMoVG74mZDNtpVHm0I0xBn6gm1SZ83FP?=
 =?us-ascii?Q?ZItrVyxZjfymAIYeZ36NQBNSBYvqz4dsiWGZQpIP4h4MLwfGm7h7OTmxM1x4?=
 =?us-ascii?Q?HTh9EP5ChDbv64kvGr27EjibkhJ4uxcqkhIfXFRPWhAC8O/JesNqzUO/fitW?=
 =?us-ascii?Q?nsWY/RLb/hhyauwwRtxFK8SDsCNwwGvZUgv+9jsGMZnpN7kg6HYQPFIha0WP?=
 =?us-ascii?Q?7PnqK2/ERZ/V4l9dq8OjR1DE/vbaXG0RgqUR3XI97Odqu4L/h8/dgZGexhKf?=
 =?us-ascii?Q?i3218OhebepSFpdLLE+mi29roTX1C3QdrpLOFBdbmCZ/ljKC/BzYtGpQmImy?=
 =?us-ascii?Q?DenCjOkRrq7DWIohlcrTxcXb8FJQWI4P0TmHUbjGLow/gur4RZZfx33Dr2nh?=
 =?us-ascii?Q?m/iUKqgbQQMSUKDGCLhsT9Zq+2JO1QPzGQ=3D=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uQA8carrKMZG5nei7NgD1y8rmmM1FMopOxtWF0vvBKUh4cxe6JpaE7SdjLCG?=
 =?us-ascii?Q?Rl9qAJO+tk7n4MlXwo+oZiDHBc/f4Jy+GCJ0SduZTtNywJHY5mjA79Qy8MzN?=
 =?us-ascii?Q?suWF852nJZCMku5epmg7M1zGEehWWGAHGNpIzDnKhDelgkJRBAufJ1aE/vXa?=
 =?us-ascii?Q?dh9XiwEiEuXt01erR/bh7Bk+jYyq4u/C2g3gJre+BEppq/QyqBaS/lwp2+KC?=
 =?us-ascii?Q?fYb+O3Vg5jcO4r56aIOOFXsfSOHNsLFmVghUaZhWGrUmY6WbUeLSezkHqBxy?=
 =?us-ascii?Q?H1f0AoRpubIPHq5oU9K2RrOXS0A4t7yfO6N+JmYmEV3Zm1z55DKWQDgeAIsY?=
 =?us-ascii?Q?GRSRNyKq3kHeylwoj74y/PA7xdX9ABIb6AiEsDC7/AKTFiXxbA9KnCYfqjEm?=
 =?us-ascii?Q?oI8pEeyS2bIqNdmMy/J3GDyAaaLHQCCuSFRDZeoyaGilO2o3PjT5F13mnMM6?=
 =?us-ascii?Q?1miZnJmLT2GXVXcj6/QQ6MBDJQoR+j2yINWX+F/e4CfnFzN+KI7F5EGg91LH?=
 =?us-ascii?Q?twSBfgs0Tk9c3iGfjo6yzNYCDm/qxpeyP8PfAQ0IzQhObyICq1OJxqCZpMXu?=
 =?us-ascii?Q?3vzEXWAERNDHCq9OlakAzGDbXxZgBuZ8JneMGDgLd3FE11IgEwCCmlrLaCB2?=
 =?us-ascii?Q?BthUphBS5n1frddMwZBuCn14wGGIJ/vRsUFCJVvztSBqBLQgGowM5DHac28R?=
 =?us-ascii?Q?ISuDEea/j/7IVGzIogR5fTTqL0vdJ6XLg/MaSwtZhEP0WLtjx7SjzpqEpAS5?=
 =?us-ascii?Q?Ls8xTnHijiTuJj5iZUUVtZNgZl069LsSsEOZ2XtKcWkvusYeBElrbjoY1K8w?=
 =?us-ascii?Q?P630dvPl7HwOuXCggzdW+DvqXEDGsS4LGZQXiqodQyJ2zeFHvO2kYFfKL/ya?=
 =?us-ascii?Q?eewtBVZYZNS1C7/mzAhcvzNzrRadUYqJMNqpKjSMe+vWtXmAWaR5H+PumObj?=
 =?us-ascii?Q?NvoT/CJewgu3Nxv3gl4ghc0DxPNMRQRTmXFP07F5h7YhJAReaxVu7AP3WDJH?=
 =?us-ascii?Q?W/lw6NiTBMTr/UXgDWeIrdw2CBLnIcJ8GPbdWRJ9sF8PyQOU5Mc2QnCiyLbP?=
 =?us-ascii?Q?2pHNts6crqE5f8GdfBwEiK0nbYQBFD7E+hMBfPVzGUTZS6AKWNKn9dt0zy2s?=
 =?us-ascii?Q?ey9FZiXmb7Ry9UgfvJbFVo5sIATsTwQAtYmblNB6V4KRYO1y2XU8my4h//3t?=
 =?us-ascii?Q?JY2nn6mVnhxX9wF3c+RmqUl004hg/0UgoTa8/GcL80L7Z2Mz0GtpuI4uDAig?=
 =?us-ascii?Q?NSrhVMx3CooqM6D5jCv5AOiLWZ8i/s17/HqabyihwRn5uSzDqTrKjGcxibj8?=
 =?us-ascii?Q?GKX4WBsdKTx3S1AC6hoOobZF?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed5e315b-7c7e-4c4d-1307-08d93b989f3c
X-MS-Exchange-CrossTenant-AuthSource: AM9PR08MB5988.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2021 07:28:14.3353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vxi5tX1Nti4OQRmmqLfs+YuHXWbORWfaj9WmaABa1nFYpbh53q5wTizXnYNmnrUksvViGAhuXu6kusUbANPRkE2NK72iZeUA8kVf47TRPmU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6004
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 21, 2021 at 07:09:51PM +0300, Valeriy Vdovin wrote:
> On Mon, Jun 21, 2021 at 05:50:55PM +0200, Markus Armbruster wrote:
> > Eduardo Habkost <ehabkost@redhat.com> writes:
> > 
> > > On Mon, Jun 21, 2021 at 10:07:44AM +0200, Claudio Fontana wrote:
> > >> On 6/18/21 10:40 PM, Eduardo Habkost wrote:
> > >> > On Fri, Jun 18, 2021 at 07:52:47AM +0200, Markus Armbruster wrote:
> > >> >> Eduardo Habkost <ehabkost@redhat.com> writes:
> > >> >>
> > >> >>> On Thu, Jun 17, 2021 at 05:53:11PM +0200, Claudio Fontana wrote:
> > >> >>>> On 6/17/21 5:39 PM, Valeriy Vdovin wrote:
> > >> >>>>> On Thu, Jun 17, 2021 at 04:14:17PM +0200, Markus Armbruster wrote:
> > >> >>>>>> Claudio Fontana <cfontana@suse.de> writes:
> > >> >>>>>>
> > >> >>>>>>> On 6/17/21 1:09 PM, Markus Armbruster wrote:
> > >> >>
> > >> >> [...]
> > >> >>
> > >> >>>>>>>> If it just isn't implemented for anything but KVM, then putting "kvm"
> > >> >>>>>>>> into the command name is a bad idea.  Also, the commit message should
> > >> >>>>>>>> briefly note the restriction to KVM.
> > >> >>>>>>
> > >> >>>>>> Perhaps this one is closer to reality.
> > >> >>>>>>
> > >> >>>>> I agree.
> > >> >>>>> What command name do you suggest?
> > >> >>>>
> > >> >>>> query-exposed-cpuid?
> > >> >>>
> > >> >>> Pasting the reply I sent at [1]:
> > >> >>>
> > >> >>>   I don't really mind how the command is called, but I would prefer
> > >> >>>   to add a more complex abstraction only if maintainers of other
> > >> >>>   accelerators are interested and volunteer to provide similar
> > >> >>>   functionality.  I don't want to introduce complexity for use
> > >> >>>   cases that may not even exist.
> > >> >>>
> > >> >>> I'm expecting this to be just a debugging mechanism, not a stable
> > >> >>> API to be maintained and supported for decades.  (Maybe a "x-"
> > >> >>> prefix should be added to indicate that?)
> > >> >>>
> > >> >>> [1] https://lore.kernel.org/qemu-devel/20210602204604.crsxvqixkkll4ef4@habkost.net
> > >> >>
> > >> >> x-query-x86_64-cpuid?
> > >> >>
> > >> > 
> > >> > Unless somebody wants to spend time designing a generic
> > >> > abstraction around this (and justify the extra complexity), this
> > >> > is a KVM-specific command.  Is there a reason to avoid "kvm" in
> > >> > the command name?
> > >> > 
> > >> 
> > >> If the point of all of this is "please get me the cpuid, as seen by the guest", then I fail to see how this should be kvm-only.
> > >> We can still return "not implemented" of some kind for HVF, TCG etc.
> > >> 
> > >> But maybe I misread the use case?
> > >
> > > A generic interface would require additional glue to connect the
> > > generic code to the accel-specific implementation.  I'm trying to
> > > avoid wasting everybody's time with the extra complexity unless
> > > necessary.
> > 
> > If I read the patch correctly, the *interface* is specific to x86_64,
> > but not to any accelerator.  It's *implemented* only for KVM, though.
> > Is that correct?
> > 
> Yes, it's a x86 specific instruction, and KVM is a bit of implementation
> detail right now. It could actually have stubs in other accels instead
> of CONFIG_KVM.
> 
> > > But if you all believe the extra complexity is worth it, I won't
> > > object.
> > 
> > I'm not arguing for a complete implementation now.
> > 
> > I think the command name is a matter of taste.
> > 
> > The command exists only if defined(TARGET_I386).  Putting -x86_64- or
> > similar in the name isn't strictly required, but why not.  Maybe just
> > -x86-.
> > 
> > Putting -kvm- in the name signals (1) the command works only with KVM,
> > and (2) we don't intend to make it work with other accelerators.  If we
> > later decide to make it work with other accelerators, we get to rename
> > the command.
> > 
> > Not putting -kvm- in the name doesn't commit us to anything.
> > 
> > Either way, the command exists and fails when defined(CONFIG_KVM) and
> > accel!=kvm.
> > 
> > Aside: I think having the command depend on defined(CONFIG_KVM)
> > accomplishes nothing but enlarging the test matrix:
> > 
> >     defined(CONFIG_KVM) and accel=kvm   command exists and works
> >     defined(CONFIG_KVM) and accel!=kvm  command exists and fails
> >     !defined(CONFIG_KVM)                command does not exist
> > 
> > Simpler:
> > 
> >     accel=kvm                           command exists and works
> >     accel!=kvm                          command exists and fails
> > 
> Well, it accomplishes not having stub implementations all over the place.
> But looks like having the right error message in stubs really seems more
> appropriate.
> 
> Your reasoning is pretty clear and in the light of it I now fill that
> platform in the name is better that one of the possible accel implementations
> in the name.
> 
> So should the command name be renamed from 'query-kvm-cpuid' to
> 'query-x86-cpuid'?
> 
> And considering CONFIG_KVM, I guess it would be better to drop this ifdef and 
> instead put stub functions in several places? If yes, please let me know
> the exact list of places that should have that stub, as well as the right way
> to state the "unimplemented" error for these stubs, (sorry, this last
> one is just to shorten some of the iterations)
> 
> Thanks.
Hello.
I'm waiting some kind of response/confirmation on this message, so I could continue.
