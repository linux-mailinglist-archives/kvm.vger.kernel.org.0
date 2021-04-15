Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9223611E0
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 20:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233955AbhDOSQb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 14:16:31 -0400
Received: from mail-bn8nam11on2076.outbound.protection.outlook.com ([40.107.236.76]:62944
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234208AbhDOSQa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Apr 2021 14:16:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oCeJZ/8zrFvbIsHC4OEMXM8rTfTOOc9ARbxaoMs2icNRsxLwsiQ3y3bzvinA46zv1pXhfeeOreZkf+039r0w1+8LrUdDt0gRFamRTI/AlwCJnNNWfa4kbOfFgfW09dr+OffVGn2Pvij00dJ0Q4utUYC4qrlNqnF+ow/fu7LqDixhfFzMLBY1mFznDC+chogEgQ/a1EnctnPri8Av4Fl3vVEhwnlpNAQ9alyehvqycZP0n9MbJT0d0MjXG2izipIQJoI+sE8baXUJWkoiXVSKxmUmFWQF4l2uexlekzlbPXTIzEYvyOODXmxUCEZo78YH1kQ7NJwj1XFXIlgYlMOYww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G/Y332VLG+AQjWeOX7RuAvOwtfcj/AHxLPSqfqGFAVc=;
 b=VBbw3LwqzS9v9zEQ9lg6+1abEO0oqo/Asr+b2lXEOhJDmh3C9cVy4jvLfhAfscLusRcl/v6oYGZz6ZpfJw64hyri2/9b8yy/X2m7tufR/Zs7VhoMEGZyh1d5RIhgmHgsdPMg+q+j6NxjeTiJwj0vhDLnv2GXyIm9DDfqBWhOPZpAv4I98oTI723sGJREtqn2+1vtOs+NCFAMZlJY6P5ZtV1Bp41Y7i2eEwsFp7ajLdjQcXfuaVUVKr9nQ8XdUWxlJ8rXpoSmx05zXkshxuULmG0xeCZJaTVWPDgmanyaWV4RSDJIzWHXU1t5EEfnera6iRk9kLK1TIRoQtS1b+Xi3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G/Y332VLG+AQjWeOX7RuAvOwtfcj/AHxLPSqfqGFAVc=;
 b=ut2vUmCDV+QDT17WHq0W61n0E05tz7IHVZDGrsBTQaiqsoQl+isT3gWLQNL4QEGHiUi7BqNcerv1Fy388yjhL4ABUUtdqkxOTn7amB5KVK9dVUFHETWmA/ij+AB1LSihDhMvoKbLw8/dICEkGcL12D6neVlQEVuh2kV3qE1Ccbo=
Authentication-Results: csgroup.eu; dkim=none (message not signed)
 header.d=none;csgroup.eu; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB3466.namprd12.prod.outlook.com (2603:10b6:5:3b::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4020.16; Thu, 15 Apr 2021 18:16:03 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9%12]) with mapi id 15.20.4042.018; Thu, 15 Apr
 2021 18:16:03 +0000
Subject: Re: [PATCH v2 0/8] ccp: KVM: SVM: Use stack for SEV command buffers
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@suse.de>,
        Christophe Leroy <christophe.leroy@csgroup.eu>
References: <20210406224952.4177376-1-seanjc@google.com>
 <3d4ae355-1fc9-4333-643f-f163d32fbe17@amd.com>
 <88eef561-6fd8-a495-0d60-ff688070cc9e@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <967c3477-f680-2b49-0286-0d3418597d89@amd.com>
Date:   Thu, 15 Apr 2021 13:15:59 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <88eef561-6fd8-a495-0d60-ff688070cc9e@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SN7PR04CA0021.namprd04.prod.outlook.com
 (2603:10b6:806:f2::26) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN7PR04CA0021.namprd04.prod.outlook.com (2603:10b6:806:f2::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Thu, 15 Apr 2021 18:16:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5b4b68e6-dc99-469b-7c49-08d9003a875a
X-MS-TrafficTypeDiagnostic: DM6PR12MB3466:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3466BEEE43C0588F38D7A5C0EC4D9@DM6PR12MB3466.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JuxM4Fbsld6PDIRBTexR2G2TMqDzzLU1aeeSxLfWR7dR3AJX8BIM3P0QSzK6aUc1T97szjvG8iFPhLSmgYtNk3mgg48DIJxRU0F3cH1X/k4VVLC4OUjbAMTB74foATfojGQeGSejsZZwDigWuRJOHoxnn6XBMpJO5yiVeQaLwW42Zk1bKZPnP6iOuaLGbmBC+G2YYOo1VDyzDiy+27CahekVLM/P5GbVp/BKG/g9bZtmx7sbwLyN61wknrojBpIGE/Jr0220Ui9USt3brCqNie9dmMlg7lv3sCnDSajMdMdORM8umA1i1eIFYAtwZMiwIS9ErjpINpgpVOv2qrlQbmuTRPPTfAYK1NwospgbF/wmLPxbx546085npdB5c0QhvJ10SNPSIkRj8SDkBgnRJMl/wY4Zgd67iSKrgVnAvWwLGGD3LK2HHcQVxXv+aaSZqMrC3150uurL7oyEEwVFy3gE1aIxDxCdzWw9XyjtMUx/xQeTyEF9KNPlY69KOWFV6016wcuk/wZqp/4lZo3gaA7J98LgnzICJrICr9P9JEnTzDCTGjzSQKD2+t4TLesaoZZOf2UE8nMiJm3pCJAp2fdwnkFUTwAFdtq4esX358SMk8bI/5Cq8wilIkpXiBBDC8QZJAj52wbVjtlRAsTE6RLAzZbW6JiGE41kMvjjm+JU5wExTUQkzbWdTif3NYfKZSc0wYd4W+/dFGfC7Q9kYbrt7jbxGhi4Yd+I4s13FGLT0lj8CzZvcShd0GooXgMBF0w6NLIAll6wJtZGZEnySA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(346002)(376002)(39860400002)(36756003)(4326008)(956004)(316002)(8676002)(2616005)(2906002)(66946007)(4744005)(54906003)(110136005)(86362001)(16526019)(478600001)(966005)(38100700002)(31686004)(66556008)(53546011)(8936002)(66476007)(26005)(6512007)(31696002)(6486002)(83380400001)(7416002)(186003)(6506007)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TVNyWDJWZlF2U3NVSFhRbWgvVlN6RkVId1czRy9qVXJDSFJ4Mm5lSzJHSVF1?=
 =?utf-8?B?bENXTThPcHNFTGJzSmdnSHNwZmtGYjJzbHd4OHljVU5TU2kxcitCRExzUW1V?=
 =?utf-8?B?TGRYejBhTitzQUdhVUVVaWNEUXBRbnRpY0cvL3NOVnRqTDRCeTJyWVIzMTZr?=
 =?utf-8?B?ZTh5VEdzblNVWDA5M0JRc0U4NWFkUk5sbmdYc011anErRGI0Wjd1cldJekEy?=
 =?utf-8?B?NmE4Y0FqOXFEck1CakkwaWtxZGlkeUxSZlg2QjNnZGFsanJmWXNoU29tM0t4?=
 =?utf-8?B?WTRWYktWNlRzVjNOc0tRL3o3bksrZmVlWmwrZHdmQmxWdFhZZGppSEYySUJa?=
 =?utf-8?B?RG8rT3Izc1k4TDlPSnFhVlFZM1VZK1VzSlErekdGWTVkTGNxWTA2b1EvSXhM?=
 =?utf-8?B?YlFoRWdTaTJuNFhoYjd0OVJNNVpOWjBTQUV2Yk1UYXBJQzV3SXJoQXFNWnVT?=
 =?utf-8?B?cTJGRnhYa0Q2Z2twdmtxdGt6UzBBY1BkUWZGai9vOWNzSGdyYUxJQ1p4dVhW?=
 =?utf-8?B?c0lKTUIvZWZtMjcvdFp3VERNNnJpbjBGMzBidVBUc0hqa05oa28ydU11NzBr?=
 =?utf-8?B?UHlycWQ3MVRDUG5raDdNMnFaeTR1MXhmYmRwNW5QNEx1aEV6ejI2ZVhwZ1ZD?=
 =?utf-8?B?MlFFZjMzZXBoUTcrZEZjZ3NYOEI5VEQ4eHg2cGkzSXdZRVp0Y3VVUWxrWTI4?=
 =?utf-8?B?NDlnMlZpM2NDanlFejFBL3RGRG0rc282MHdER0lkbkxxdU1iRDNxQmJIenNj?=
 =?utf-8?B?RlhHYnhCbHJnNzBxcGp5QWJvOUt4WTk3bFA5MDIvQ3JwYkhTR0x1T3ZVOWpL?=
 =?utf-8?B?bU4vbUxWcFFsMnU2cktkbmlvaWRHUTlVNjF1dG9RYURyQkY1R3ZHY0xjQUIy?=
 =?utf-8?B?V29JbjNEV21kQXdWdnBxaGt2Y1lRK056cjNHb04vLzBwOGJ1MzY5Nm9oTXRq?=
 =?utf-8?B?R1hxUUJvTUFtL2thQUh4anl4SFE4WGlMUUVqakFMYVV2WUhJMTlLTldHVXdy?=
 =?utf-8?B?amRsUEVtR1h3cDcydytBcVBCT2V0bmFtK2dxRURzZEFPRnJSSzdQY2hJYjZm?=
 =?utf-8?B?UVNyNGFmblVpblhJMS9DalQ0cThwNlhMczFlWUlYS2lUSk5wTkxkMUlGZGNI?=
 =?utf-8?B?QWNvS2R5MVJLRzRyRG5uVzAzeVJITjNIY2VOL0xLV0dmNG5XaWlLbklYYlpE?=
 =?utf-8?B?VG9sUEJVbm54dzY1SWs1RUpSdVNXRExzY0VESEZVeWxDa0x0M1hJaGw4K0Nl?=
 =?utf-8?B?RGRQNVZPckQ3N2RVNEZwMURXRlRWTVN5c2xVak5YV1M5L0owNFU4bUZjQTlE?=
 =?utf-8?B?T3hLOEFoOEVLbTRUc1BHSHljS3VFV0tKcGhlaHdXcGtBbHZ3L1Z4ck1DdWky?=
 =?utf-8?B?bnNmaHNTOXRoSnA4WHl3eit1ZHBxN1A4VGt6UlF1djVEYks4MGNUU3pJL3Ix?=
 =?utf-8?B?MGFReENEdU1FeXBzejlvazNiUFYrSGlrZUMwZDgzZm1pbnBvZG5FQ0dKd2l0?=
 =?utf-8?B?ODB0ZUIvNUcwTkYwNzlLNmFHYjRISW9yUHpqY3gvUWxPVnphS0lhdWh4dWFM?=
 =?utf-8?B?S1ZQMmFVRkdwNHdDVnBZOStJemJiTExFNVNXK1FtekFpK2d2cnMyZnlkK0tX?=
 =?utf-8?B?a1lCSHA5VmJPQ1pOd25HK1hZTTNxc3FFMmRXclJLQWZUanZQUkk4UE9YS096?=
 =?utf-8?B?UHhOa0tYR255M1dpck9FYXZNczVTV2VIWHA2VkM0ZDRFbDdLQWFHejRJQVJ2?=
 =?utf-8?Q?qaooKp061DMM2zzgDO44EmiAqyVZQ4bCF4dqwlU?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b4b68e6-dc99-469b-7c49-08d9003a875a
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2021 18:16:03.0362
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oc5+mxPS0ifGVk1yCx405zKh/tEK8wn66FQ31a0AOspuh2kij82K+aMGu6vgfGeK7RWdTrU5ad3/8YUefW0i9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3466
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/15/21 11:09 AM, Paolo Bonzini wrote:
> On 07/04/21 20:00, Tom Lendacky wrote:
>> For the series:
>>
>> Acked-by: Tom Lendacky<thomas.lendacky@amd.com>
> 
> Shall I take this as a request (or permission, whatever :)) to merge it
> through the KVM tree?

Adding Herbert. Here's a link to the series:

https://lore.kernel.org/kvm/88eef561-6fd8-a495-0d60-ff688070cc9e@redhat.com/T/#m2bbdd12452970d3bd7d0b1464c22bf2f0227a9f1

I'm not sure how you typically do the cross-tree stuff. Patch 8 has a
requirement on patches 1-7. The arch/x86/kvm/svm/sev.c file tends to have
more activity/changes than drivers/crypto/ccp/sev-dev.{c,h}, so it would
make sense to take it through the KVM tree. But I think you need to verify
that with Herbert.

Thanks,
Tom

> 
> Paolo
> 
