Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5308F4D0E24
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 03:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240927AbiCHCzL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 21:55:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbiCHCzK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 21:55:10 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2059.outbound.protection.outlook.com [40.107.212.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B02D611165
        for <kvm@vger.kernel.org>; Mon,  7 Mar 2022 18:54:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gMmb5DkE8dd1jtZRUpQocsH/qKGumq7tCG5jtrztFnf4+Q6oKDpVgjSbEyOxp5WSXOXSn2F2hM2ukLnr21sNKP+z0DkFck98N5pxQPTAH2YX3/WEjnayWhktaFKnwEFD0jzbcFheFAMx6FibEcw2dkNBjNP9dfdNtBLj0GJKGY9Fbr+guFkfI/Oyc3JQozk1z8ihCM861qwzg/r9v81BcZu6qJPqFNzVcPSA7Ch8GbBjH6vGie+A4M7/gI1DCuUMvdadkGaqxtLjvu2QxJIroqYao+BhoZLri1yLHIcENX2IjrenFEn1Gk/OKGAKPHl8i+7c/zPawNNKH/fTGVV8gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tQupX1YpQBERrQW34w0OM8p2KuEDJSe/9mXxR24U9C8=;
 b=b1XdKkwXBsxXbJ45eETj+Tg+VEBEg/WA34hrsb8S0YqL2ehF8zuryWs6xHE9N4i/f+hQY1OUeOgpJvx+68I0jfTmPwOogCDXHX1di0s6+IjpvV1uExwvPVnvOezMNRjtQSCVDk3V68FpaMqjhIMM6z1IfvvqPK6dgOpHHsh6nsqvuGDf/IMdZUX67HQ7NrNaiSH+1lt/xRqHDUSz50OfZJjloI7oPIPdeudHbjPbd3NYj7UfvHUVQzhpYsRvHBMZjAD5RKdWnjLl4+FtWWx89M4+VfTliAj5pkMo9uNp1iqUaq2l9xUoO2rTaFKGniwWA3gxKiU5wa2RKZbOaevv0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tQupX1YpQBERrQW34w0OM8p2KuEDJSe/9mXxR24U9C8=;
 b=g+RrOY2s9LXDsTyIrs7nB5GqTqAXRdY4+vERpXXDMTA0um+s8QcEiR+WdFDpqnlRgsVKYWTNLr4phzXyuREJuDYiodvbGlLsxaWNMuOn0MeFW+58YyE1OOkGCJjc+fJT06Sr7bdnLvyOuYSzQ/dYoWqYWiEiuqZLQQmpE/szbF4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BN9PR12MB5179.namprd12.prod.outlook.com (2603:10b6:408:11c::18)
 by SN6PR12MB4717.namprd12.prod.outlook.com (2603:10b6:805:e2::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Tue, 8 Mar
 2022 02:54:12 +0000
Received: from BN9PR12MB5179.namprd12.prod.outlook.com
 ([fe80::e9be:e1be:5abe:f94c]) by BN9PR12MB5179.namprd12.prod.outlook.com
 ([fe80::e9be:e1be:5abe:f94c%4]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 02:54:12 +0000
Message-ID: <edb33ebb-a720-2a89-c19f-582a39e56375@amd.com>
Date:   Tue, 8 Mar 2022 08:24:01 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [kvm-unit-tests PATCH 0/3] Move nNPT test cases to a seperate
 file
Content-Language: en-US
To:     pbonzini@redhat.com, seanjc@google.com
Cc:     kvm@vger.kernel.org, aaronlewis@google.com
References: <20220228061737.22233-1-manali.shukla@amd.com>
From:   "Shukla, Manali" <mashukla@amd.com>
In-Reply-To: <20220228061737.22233-1-manali.shukla@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BM1PR01CA0106.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00::22)
 To BN9PR12MB5179.namprd12.prod.outlook.com (2603:10b6:408:11c::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4251ef20-a6ba-4742-e5ff-08da00aeec96
X-MS-TrafficTypeDiagnostic: SN6PR12MB4717:EE_
X-Microsoft-Antispam-PRVS: <SN6PR12MB471764DEB760A9C9FA7148BDFD099@SN6PR12MB4717.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tk/HyUQkZPrenCAcJyyM7a2KXMq6Gfq7o6j40ECa0nggtWAaaxf1ur2DRrVLyh5pM31XuRSCOfxzdWxHpcQfeS6PrM9h1teBUlizuIcNaH8F2JT1MN71s36MG0iEIG/w7hkQZhXvOuduRM89r4mlpdEHoylbiGxJSePnkQKuFIDNr7XXyj7dT04eMSMby+kq5OpDRzy3ZYjr+N6SgHuSVOId7W+KIpAV3Uo+v/ublOeu+/w3rYpzg7AconqQ+8cKmRIvEV6fm0M7DCeNDRhm8t5RIrzBxhWB7ddt8JMqIMfDeAOWuN+RiDZqx2Y8a3+1pJXPPOe0rmacGU/fanR2T9W3QxP2uKzHuzdc4WOsWunz/0H2FYHb52/Cpv/pcPPIXYthAqHbRSoUBdn2bCc18I62X00Z/brYV6qpHU1+mCanJNsi0N0zOxN1sYCJVPqoErIZXqbdYMm1GxSA7Id6HwY9rMrqU1YC8u2gtTPfFUDO7VN107eolP/Ak8o5u/skXpCUljKZi7ORrRWKg0GtSV2eg/lQyBYIb4RWd1a7KB+xc5g0mSv7gBeKtR0apJG4pJrkihqCQ1jrLv1VbRoyNCe22Y9SOQOkNL2olB6DCX5zzxY637c9xJWMY1bU2G6GRaOo9HVrQMfAjIO0n/34jCx60aegDOhQAxxChvS5G22HHvNfx6NSkhd1II0u2/L9rwUleZaOBlyznjz5iB2XZ8g3tG8oflYqViXXYAJI2s8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(36756003)(31686004)(38100700002)(186003)(31696002)(2616005)(83380400001)(8936002)(4326008)(8676002)(6486002)(6666004)(5660300002)(53546011)(508600001)(6506007)(2906002)(66556008)(66946007)(6512007)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cXdOcThmUE1ORW10RlNJcjBPUWI1cGpGNCs0VjFESDhPUEJEMW5hME1xUWgx?=
 =?utf-8?B?V3V5amFaTTA5WjVBcU1yamtZZlNyWHFaZTZWNFpaTnd0QVlzcjByM2VZaCtC?=
 =?utf-8?B?d0ZqK0d2eDJiZ2EveGZhdTlnc2xQamRHN2V6eTQvUlZSaUhtd2l5Y0JidHBl?=
 =?utf-8?B?aTFZazduU0tUMVNMampWaHFSdkVRUElPTUY2ZnV6c0hOa09lejN4VEs5RmRs?=
 =?utf-8?B?bGMrRThIRUFnNndSM0tXODJ3MXM2NVFyTlNZK3VieWJPeFBWYW54M3R6eXky?=
 =?utf-8?B?L2JoMWphenJHTm1wNDlyQVI2cEszRGE1Rnp0WjVEWFBWN2h1RGloQTFaV3VW?=
 =?utf-8?B?VTQ2MlE2L0JzYXpVVThFbG9VeHJRQlpzVWFreWRLd0VUTmg1NzZFTXlBZy84?=
 =?utf-8?B?ZWY5d0Ewb1pTck1Qc1NmZkQ2NWR6V0Q3SlZUL2VMM0VScnI3aFhTeEp4T1pG?=
 =?utf-8?B?OUpWN3lrcUg3V0xHK1BES2lCTmEzS0h5R09aMjRra0FvZmdOMm5ldnZibUlj?=
 =?utf-8?B?OHM1QUM2QysrNkNxaE9UL29ndjgzVTVYLy8yUWhrUFpiek5aaXErT3JDMzBo?=
 =?utf-8?B?RmM5OVN6WVRWRENyZHo5YmJKZlVNVTlvZCtWVmxiYmFLQjErN0xyY0FzTEZl?=
 =?utf-8?B?QzNMVnFRckpQRzhGNWJRNUhmWGZtZnVFVmZwbEllVWxRVHZQL0grRWliZHdY?=
 =?utf-8?B?S0VPWUR3TVhjT3doSG1NVlNCY1pxOVVOY0pTQ2tJRVBQTUxxZW5BOE1MSjlI?=
 =?utf-8?B?ZFEzZ1pNbHFyVXhzNTdaSU4zYitLTVZkK0NOUDdXYmsvdktIUzUzaFFrZzFl?=
 =?utf-8?B?NndSQm1RSjZBZWFkbmZZczFGdGpkTFRwVEdtN2dvVk9oZ05wWWdRUlZnTE5B?=
 =?utf-8?B?bUZVOHRjU1dpTzJKZ2hXMFZXN0tOVXBPQy9ReGdHRmMvd1hUa1ljWnZIMjJ3?=
 =?utf-8?B?TC9PZWRyWHpaeUxHSlNEaFNyUlpjTlZGVm1HaVZOY0htOGJjL2NyY2F1OWNW?=
 =?utf-8?B?NVFEek1uY3R1Q0ZmY0l3bGxkUnpYZXVjOVJJYndQT2dUeUFtODZXNzI5WmxT?=
 =?utf-8?B?QktGbDRFVFB1TFpuYWVHa2Q1dnZabHl0ZVB4YUpwNXFqYXVVTklJNmk1YkhX?=
 =?utf-8?B?L1libm9wMFlqenE3VFNDck5IK2UvK1c4M2JqeUpQTGdTcUd3bGdJd0JURklO?=
 =?utf-8?B?dFVaK0d6cWVTL2ZOTzJXOCt1RWoyNjkxKzBpWnhoSUdsVkxhd3FwMnRHbmdu?=
 =?utf-8?B?b3dqMThsLzFjd0owODRmNTdFbzVzY3JPUVVyQ1EzUWYrQzQzZEk1QlZNZFYx?=
 =?utf-8?B?a1hNY05jMFhWVkMrN1FDalcvanVRU21leFViNnMwbDUrWldEc0E4bXE1T2Y2?=
 =?utf-8?B?a29obk9pNWluWmVpSG83bW9GRWw2OTNVT1pIcHE2SHl0NEhWMW9jS09vYlcx?=
 =?utf-8?B?U3I5eFVraWxLZTcxQVMwZTdoQmxIKzJ5TExCazNaSGNsUUNkWHdjTFJwT2xr?=
 =?utf-8?B?b2xnTDYzbkl5UkdTL3Z3WGl6Rmd0anpKYnVFRzFObmJCSm5aV3dHL0FvQUlx?=
 =?utf-8?B?eXlRVnNHZncza29keGhnZnhjQUZua1ZKbFhRaXJPeGNSaEdxVGduSzBhTjZP?=
 =?utf-8?B?L01SR1hZNHI2SDA5b3hJOWY2My9kVWdQbnVtdG90bHYzUi9WaTNaQTJKOER5?=
 =?utf-8?B?QXJOT2NNVnN0SmYwOVM5TkQwb2loSTh0RlhxMXExRGtETFpvdjZGT3Jvd2w3?=
 =?utf-8?B?NzRZSWVLaFBidDFIaEJrbWJwcHIzTlV0OFMwVXR1NnZHd2swRjJHTlZGQm9n?=
 =?utf-8?B?cWkyT3dvVGJlUi9VODcvakpMUzh6aFh1RDgrTjlZQm5ITzBYckZUM1FTUHV4?=
 =?utf-8?B?M2R5UFJNYURwNndheE8xNnZqbXpRek9vaEd0RThnM0NPWEtEeGJ6ZWxtTlFZ?=
 =?utf-8?B?UTFzYVBOdGkwZUViOW1URHNSdDU1OEhmSUNBZ3RuYUE0NWJ4MXV1bEtHRkZv?=
 =?utf-8?B?SXFMell2UkxLeGZlVDR3Z3UxeE1UVXN5L2xmZVhreEhGWUdpelBTWUgrK3ZN?=
 =?utf-8?B?bEtHd2lhNW11R0o0YUtwNFZCampqdW42eXMwdGZpS3NGTm1CS01PckV0cVQ0?=
 =?utf-8?B?ZWxyTkZBZEFrc1dvR3pjQWl4R0Q1L3ZzQkJVMDFrQTl2VHB0aWFQY0RGNVRG?=
 =?utf-8?B?MG9QVmY3V0o0Y3BMTXN5UDEyZTB6WVdEdThyY0xBQi9zQWZXcjBrcWJhZnJi?=
 =?utf-8?Q?4WgpC5XJbhOsFLHAkTuaLoq9Jk352/nw/c4NOvydAw=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4251ef20-a6ba-4742-e5ff-08da00aeec96
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 02:54:12.3093
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K3dBriVZ6JSzVic3m4LLWUQ+LW1qT56qVggg0rrOTdpwNlVrlDs4Mp0IcRJVxGqU8+A50rUQM9QZ1w6otI2lPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4717
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2/28/2022 11:47 AM, Manali Shukla wrote:
> Commit 916635a813e975600335c6c47250881b7a328971
> (nSVM: Add test for NPT reserved bit and #NPF error code behavior)
> clears PT_USER_MASK for all svm testcases. Any tests that requires
> usermode access will fail after this commit.
> 
> If __setup_vm() is changed to setup_vm(), KUT will build tests with
> PT_USER_MASK set on all PTEs. It is a better idea to move nNPT tests
> to  their own file so that tests don't need to fiddle with page tables
> midway.
> 
> The quick approach to do this would be to turn the current main into a small
> helper, without calling __setup_vm() from helper.
> 
> There are three patches in this patch series
> 1) Turned current main into helper function minus setup_vm()
> 2) Moved all nNPT test cases from svm_tests.c to svm_npt.c
> 3) Change __setup_vm to setup_vm() on svm_tests.c
> 
> Manali Shukla (3):
>   x86: nSVM: Move common functionality of the main() to helper
>     run_svm_tests
>   x86: nSVM: Move all nNPT test cases from svm_tests.c to a seperate
>     file.
>   x86: nSVM: Allow nSVM tests run with PT_USER_MASK enabled
> 
>  x86/Makefile.common |   2 +
>  x86/Makefile.x86_64 |   2 +
>  x86/svm.c           |   6 +-
>  x86/svm.h           |   1 +
>  x86/svm_npt.c       | 386 ++++++++++++++++++++++++++++++++++++++++++++
>  x86/svm_tests.c     | 369 +-----------------------------------------
>  6 files changed, 398 insertions(+), 368 deletions(-)
>  create mode 100644 x86/svm_npt.c
> 

A gentle reminder for review

Thanks 
Manali
