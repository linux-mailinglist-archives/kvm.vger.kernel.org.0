Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B691E3F184E
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 13:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238988AbhHSLhK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 07:37:10 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:52719 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238454AbhHSLhJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Aug 2021 07:37:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1629372991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=04b+NE4w/cLhOZi/S3EFpSodgKUUbHQ/SWtYgCYi4Hk=;
        b=YTEnpJGVUcXvR2plamPzMf0UC0wo6ea87kJCkWQPzHDNbsYsyvViWjymvHX/IjvhJghOyc
        qq65qSdlqL1miv4Aohtc3qe2PIIyoTAIzFh93sFPGzZS0YQl6T3twFiKsp7pr9wh+UCW86
        1XVSOJoNWr5Et8qCuKbKP+19tdFZYX8=
Received: from EUR03-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur03lp2055.outbound.protection.outlook.com [104.47.9.55]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-27-yeLtHeXlPreNzmDFkygy0g-1; Thu, 19 Aug 2021 13:36:30 +0200
X-MC-Unique: yeLtHeXlPreNzmDFkygy0g-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XZEpD870zTFDeesr3WPiKX5qdDokXLGBJPsc3iqAussQX/M5XQjaZpFP+DQOc1k2h+ETRa119LZj50JCWkydkQ4oWUwtlh0eh0RPz4pQtPy/13CjCoS40vKrjTzbpadbLwyZiFzLDW/xnYmhxe1jGRwpHqwakJ95XGPe/uLaNgvbRXDb1z1milMONlVmqiL0F0JL/dvEbtyWu+Tz3oJ9d6oaX7ADSyTUn07kO6kuEWCbYroCle2onaUMdyAZuoqiXLc82wtuhmg0KyqCmCuXj2QyQ6fBJv6MGOcImrGDg1iztBVWkidjXaX00sL6LDi90wdD0C6Vu/q9iLrPNBCbXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rv8ArHVpuKh3DwOdxYZkF2y7SE0mzb8kJhrbRfF08Wo=;
 b=DAOUMjOImoALO9Xl/41JBtObYILrZVK3OnF1tWFdXj3jigmpOYWYlQGW7aFWT/8VOJiIPki8PfepAQeF5hUKbTg/W6cXEngfPF/M+HU2G71HHRQpgKJevWXnFdFmLAocvBMmDpwdJRXaeE6Z4HCF9BCmmG6fF9RenSMat3k8/elqWsvcxMqLwDHgQxOME7iE5MTv6aBiSPUMsTZlMNS5IPZYkcQknSnkD7bSNUkPtOUC8eW8BNTpZ7rzq1nE4XzkWHZsaeUFfZGfoMfD5Pwp17ydyn21cDhz3eX/EAf3ieM22gTUBWRezVICP1IfiOS0xlQvxPjcqfW7gDnSgmq/6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com (2603:10a6:208:128::18)
 by AM0PR04MB6866.eurprd04.prod.outlook.com (2603:10a6:208:183::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Thu, 19 Aug
 2021 11:36:28 +0000
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::3d8a:3492:1e60:36af]) by AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::3d8a:3492:1e60:36af%7]) with mapi id 15.20.4436.019; Thu, 19 Aug 2021
 11:36:28 +0000
To:     Marc Orr <marcorr@google.com>
CC:     Joerg Roedel <jroedel@suse.de>, kvm list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>, bp@suse.de,
        "Lendacky, Thomas" <thomas.lendacky@amd.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        Zixuan Wang <zixuanwang@google.com>,
        "Hyunwook (Wooky) Baek" <baekhw@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Tom Roeder <tmroeder@google.com>
References: <20210702114820.16712-1-varad.gautam@suse.com>
 <CAA03e5HCdx2sLRqs2jkLDz3z8SB9JhCdxGv7Y6_ER-kMaqHXUg@mail.gmail.com>
 <YRuURERGp8CQ1jAX@suse.de>
 <CAA03e5FTrkLpZ3yr3nBphOW3D+8HF-Wmo4um4MTXum3BR6BMQw@mail.gmail.com>
 <71db10eb-997f-aac1-5d41-3bcbc34c114d@suse.com>
 <CAA03e5H6mM0z5r4knbjHDLS4svLP6WQuhC_5BnSgCyXpRZgqAQ@mail.gmail.com>
From:   Varad Gautam <varad.gautam@suse.com>
Subject: Re: [kvm-unit-tests PATCH 0/6] Initial x86_64 UEFI support
Message-ID: <ffae117c-4961-c0de-1f17-7092b7bc3d65@suse.com>
Date:   Thu, 19 Aug 2021 13:36:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <CAA03e5H6mM0z5r4knbjHDLS4svLP6WQuhC_5BnSgCyXpRZgqAQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: PR3P189CA0008.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:52::13) To AM0PR04MB5650.eurprd04.prod.outlook.com
 (2603:10a6:208:128::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.77.189] (95.90.92.25) by PR3P189CA0008.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:52::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Thu, 19 Aug 2021 11:36:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eeb4e5c6-f127-455f-8e4d-08d963059572
X-MS-TrafficTypeDiagnostic: AM0PR04MB6866:
X-Microsoft-Antispam-PRVS: <AM0PR04MB6866B23ABB7C81E5D048E172E0C09@AM0PR04MB6866.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SmE9COcJ+Dv5vtj3xNRxHAH2xouMkuyQlwkiqwhqa+hXcmxTjm1ISdl+xJtn0MMjnGuuF/IT3wEr7iH+UVcqq3no06BSL3x5mkWqJZaYY1Dc1QtNfLsZlkRJkJCqhJekv+yocRUDkH6867WnAC0CHuAS9dKvkb4dNBdFPxG3GL1FJqYcuiOWt5tBAT5HmYV3QGewqe/ln7/pkzZAuQxvJ3ii9C+eeznpW/vCLhXdv8nZoSgTWJCc+Ov7b7F5TcfXHiShkoZZ+k4KqPU8LlBzvFhYArDs0UzW+TiewMyMqPafhrICAE80xNbN3LyU+0b7A/GYxrZer2kLQEyMo4Afn2erVyg044dL+4EpEeZPLRbjchntkl2h2g/C6Uv6Vm3ZnfKUlkLzxuxd8ZtMnYwdKChK1zFdYTrrrAAT8A2UYBVxeMUbFp9B89oza0ORwFQuL3Bz7yEPu8D+V4b8KPqfLot3GDtfSbM53UXJP0mDpuYmS9saOyxDGJ2bfN3PyjtBQEQgT1dlzXFVRHQwWozxclHoYxqvS2eQM//WXyQtQ7nN3RHXNNaOx+/KHLdc7Gjb4jWf5PpE80ZIhUnYAwjkynDL4WJXRwrRH/Q0+WdKNJFxaBHiZdSk6JZPbfbeQxbvHwW96ZiBWZAWVE/o4NCnVx5XjznGy02Ub3HAeef0yXATC672yUXrEOL7xNLg+G9lGRjJ/TZFxpbnIIkklKqaJcieYvX/RYEm3smt8ktnOHsU2//H2ejQY7pTf/VWmEmuOGZohAzTiIuqRBFfEX8nTVdW9rXbLRoEJO2KlmPB5jpR+gGK0Y2BrWpUOQCGjPHJI08yWT7UclStTQ6wqN7vfU6mpAFYLIK9/+lW1r7VJhY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5650.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(366004)(39860400002)(136003)(83380400001)(316002)(66574015)(86362001)(16576012)(6916009)(966005)(54906003)(8676002)(31696002)(26005)(36756003)(38100700002)(6486002)(478600001)(186003)(66476007)(5660300002)(66556008)(4326008)(44832011)(956004)(2616005)(8936002)(2906002)(7416002)(53546011)(31686004)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wAc9rgdg5cnm9qRirzkO/61f5uWaHIW4brG42mBHruzmofEU6Sf55W6+lQUC?=
 =?us-ascii?Q?sVYqvLZWcFigHllaxBdx55JiP7x3LlE5LDbpqIt9E9kRH7r2H4p1y6mQtfao?=
 =?us-ascii?Q?C2Dh1aDg0Zol9n8RBs9DHoZ+HNPyy6sySSmQBItH3EoGdUL1Qze0osTaGBpo?=
 =?us-ascii?Q?2hU4XOIOGBxlMK3Dewf2zn2tv62SFyYIMMQ2KGaN1g0iHuBARmvckt4Xts3n?=
 =?us-ascii?Q?HXmytf+1t1OtWtR04hvEuyPiDBvFrRtLH8qSIZd+l73hBBRMrhHxiX1BJraU?=
 =?us-ascii?Q?Vm9ow3JDEgUIigrN8eH8gRHHjw6xVz/H/Wq0E5mwGyWs7fLM7LZFH0f/Q8dE?=
 =?us-ascii?Q?v7a0cO8QXf7nqjNjFRrPMybys0BrceNFzKqdaN5nM/0pcWhCfNVRzr+gt40q?=
 =?us-ascii?Q?XT5SF6ayEq3fj6nYU3XjLSqBmyTqM4oWxzyJhvGHEORNsnEdv8GWmbCFMafg?=
 =?us-ascii?Q?fMZUicGoLGz8nH5CZkSw8HgwZId6vvBvOGFVzOYLwYUwrAkJkiJc3geYHrRh?=
 =?us-ascii?Q?cqdAEDwiW73WJ+CfYtHOUNRWhFDsxFvrMuzk5hySzs4fkr52MWwZGmt2WSws?=
 =?us-ascii?Q?AfcS4vylB7ZeUCpub+07lv9N5xQUS3mg4Cxu7TtDxzTgc5t9+9smjXbSocP2?=
 =?us-ascii?Q?p4MtCEXClxcZlISzIYnqvOL63j2Hl6K/+pa9gaEpPBMgXYAE7mhxVZ9tAf7n?=
 =?us-ascii?Q?vqpo/33p/YM87G3cI4r9WolHqVVK50n2cO6ly8so7h+vumWTNWWXdl/ADtcY?=
 =?us-ascii?Q?fmHa/tNNJxNq5uxkmz9yFz6qyTAHlUQ9M8MGf3bHlprCVD5+qaF6HunM+pUx?=
 =?us-ascii?Q?w9Z3N2iIERdV1tNjdeu9jqRsyGdPGtVkFNPgPYhaIq9b8Q3cfJw8eJt48DbP?=
 =?us-ascii?Q?LQfmn5tsfCeWWnezMB7sOiOmbCoWLU3cpvXB721snmif8XiSHiejdU9kGadd?=
 =?us-ascii?Q?1nP5pnoO3Z/Xeyrkh46bWgc/crLImsfB1p/K6q0WapvWOtN7aAsUfIUvznp9?=
 =?us-ascii?Q?ztFcA0N6dIg4iaQKMWyAilc1BgXlzku2pUxhUvMUpp/cK5V2fRFj+r+JeUHC?=
 =?us-ascii?Q?IZMCq2l2zLhUPv8CtoO6UO4PGpkGgFeLV85UUycqc/8JdWWMLrXF2Pocp/ug?=
 =?us-ascii?Q?7Sa/hPafly63w1qu1nsZu+TmcOuiPtdxPie9Hvx1z44D0OOhjjJDtpEdi6Xn?=
 =?us-ascii?Q?vVNFTHVOCrJ51+aNo6tuT/8/aHe4dpqOzrNgWPe9e7gL4IZ1fQ5mFugoyY4y?=
 =?us-ascii?Q?Ppah9NZ25xwroHGsH0X8UWrZMlt0JK7OoKK8qW+N2oWoGPjHnAJKYHGJyHo6?=
 =?us-ascii?Q?W5ymv5g03JLdtgnSuZ+e3aQJ?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eeb4e5c6-f127-455f-8e4d-08d963059572
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5650.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2021 11:36:28.6272
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9LIhBkiPYbMjEUl32QgDRGEqnpxMtmLHY9XDnv7Vxs7WMljLBK55JyaFteGq4i7jhiIXy0AtcEC/BTul7XdOWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6866
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/19/21 3:32 AM, Marc Orr wrote:
> On Wed, Aug 18, 2021 at 1:38 AM Varad Gautam <varad.gautam@suse.com> wrot=
e:
>>
>> Hi Marc, Zixuan,
>>
>> On 8/18/21 3:52 AM, Marc Orr wrote:
>>> On Tue, Aug 17, 2021 at 3:49 AM Joerg Roedel <jroedel@suse.de> wrote:
>>>>
>>>> Hi Marc,
>>>>
>>>> On Fri, Aug 13, 2021 at 11:44:39AM -0700, Marc Orr wrote:
>>>>> To date, we have _most_ x86 test cases (39/44) working under UEFI and
>>>>> we've also got some of the test cases to boot under SEV-ES, using the
>>>>> UEFI #VC handler.
>>>>
>>>> While the EFI APP approach simplifies the implementation a lot, I don'=
t
>>>> think it is the best path to SEV and TDX testing for a couple of
>>>> reasons:
>>>>
>>>>         1) It leaves the details of #VC/#VE handling and the SEV-ES
>>>>            specific communication channels (GHCB) under control of the
>>>>            firmware. So we can't reliably test those interfaces from a=
n
>>>>            EFI APP.
>>>>
>>>>         2) Same for the memory validation/acceptance interface needed
>>>>            for SEV-SNP and TDX. Using an EFI APP leaves those under
>>>>            firmware control and we are not able to reliably test them.
>>>>
>>>>         3) The IDT also stays under control of the firmware in an EFI
>>>>            APP, otherwise the firmware couldn't provide a #VC handler.
>>>>            This makes it unreliable to test anything IDT or IRQ relate=
d.
>>>>
>>>>         4) Relying on the firmware #VC hanlder limits the tests to its
>>>>            abilities. Implementing a separate #VC handler routine for
>>>>            kvm-unit-tests is more work, but it makes test development
>>>>            much more flexible.
>>>>
>>>> So it comes down to the fact that and EFI APP leaves control over
>>>> SEV/TDX specific hypervisor interfaces in the firmware, making it hard
>>>> and unreliable to test these interfaces from kvm-unit-tests. The stub
>>>> approach on the other side gives the tests full control over the VM,
>>>> allowing to test all aspects of the guest-host interface.
>>>
>>> I think we might be using terminology differently. (Maybe I mis-used
>>> the term =E2=80=9CEFI app=E2=80=9D?) With our approach, it is true that=
 all
>>> pre-existing x86_64 test cases work out of the box with the UEFI #VC
>>> handler. However, because kvm-unit-tests calls `ExitBootServices` to
>>> take full control of the system it executes as a =E2=80=9CUEFI-stubbed
>>> kernel=E2=80=9D. Thus, it should be trivial for test cases to update th=
e IDT
>>> to set up a custom #VC handler for the duration of a test. (Some of
>>> the x86_64 test cases already do something similar where they install
>>> a temporary exception handler and then restore the =E2=80=9Cdefault=E2=
=80=9D
>>> kvm-unit-tests exception handler.)
>>>
>>> In general, our approach is to set up the test cases to run with the
>>> kvm-unit-tests configuration (e.g., IDT, GDT). The one exception is
>>> the #VC handler. However, all of this state can be overridden within a
>>> test as needed.
>>>
>>> Zixuan just posted the patches. So hopefully they make things more clea=
r.
>>>
>>
>> Nomenclature aside, I believe Zixuan's patchset [1] takes the same appro=
ach
>> as I posted here. In the end, we need to:
>> - build the testcases as ELF shared objs and link them to look like a PE
>> - switch away from UEFI GDT/IDT/pagetable states on early boot to what
>>   kvm-unit-tests needs
>> - modify the testcases that contain non-PIC asm stubs to allow building
>>   them as shared objs
>>
>> I went with avoiding to bring in gnu-efi objects into kvm-unit-tests
>> for EFI helpers, and disabling the non-PIC testcases for the RFC's sake.
>>
>> I'll try out "x86 UEFI: Convert x86 test cases to PIC" [2] from Zixuan's
>> patchset with my series and see what breaks. I think we can combine
>> the two patchsets.
>>
>> [1] https://lore.kernel.org/r/20210818000905.1111226-1-zixuanwang@google=
.com/
>> [2] https://lore.kernel.org/r/20210818000905.1111226-10-zixuanwang@googl=
e.com/
>=20
> This sounds great to us. We will also experiment with combining the
> two patchsets and report back when we have some experience with this.
> Though, please do also report back if you have an update on this
> before we do.
>=20

I sent out a v2 [1] with Zixuan's "x86 UEFI: Convert x86 test cases to PIC"=
 [2]
pulled in, PTAL.

[1] https://lore.kernel.org/r/20210819113400.26516-1-varad.gautam@suse.com/
[2] https://lore.kernel.org/r/20210818000905.1111226-10-zixuanwang@google.c=
om/

Thanks,
Varad

> Thanks,
> Marc
>=20

--=20
SUSE Software Solutions Germany GmbH
Maxfeldstr. 5
90409 N=C3=BCrnberg
Germany

HRB 36809, AG N=C3=BCrnberg
Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=B6rffer

