Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD21162B8B7
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 11:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232117AbiKPKeh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 05:34:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238581AbiKPKce (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 05:32:34 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2084.outbound.protection.outlook.com [40.107.220.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B83CA3FB8D;
        Wed, 16 Nov 2022 02:28:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hV9eRr+tMgYI+Zg2FMov3XI+9C2rixjGMnah/voO6YzDAQRUpjfnDYvgVXN7NxJje2fORyMEJonz+UMyoTLXD0//L9n3dC4/nKRXau9Za2LzU3XnHUXUPlJGJz0WJMZ0vU7zO5m8xR2heHk8PVigwCZdw21qzCjSCjQq9MYRj05yYwzeZZy+l4+Cw5rkZ5ynyrls70tUD3EEoDaHzUx61M9/OjR9LqTLxXVGWUjWGGoRY3Jwb2vAcV6IQpJN5ZCZUH49pYJsRZBSCW9NeweSMFiD1PwIbu82yHNah/wqqXtUcArfVy/aHVp4sxbYPSg6baDWUTyMXMXa1L24fKtOJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CLmzPGdRp3Ba7Qv6cXtUtq47Hmy0aDVTWu8cjCazDH4=;
 b=aV8yKhbNoLPV4VVNr13/95VDSePER8vlf1QyAc7PUnPmmjb78/DdJ+phRaQF+biE6r7H6MCHJLZMrpEDVgXaadVIKRUxHTp3KQcm2BVcNkWooUnBlKXi3cZiCbHdH9ton9F6rNRXrfKj9BTEdfhj1qn5fDdB9PfasKMzeMFNWxgL+EIhIHoJv6F+mSP+8Xb9IFOD9ffFKfzB9KaNi5IZhZMVcKIoMYcISpwmzYhNqaQjx/x+o9Cy+o6aJn/JpAjj17T6sRsz/tQo0da3R5lAGj2Wd36nc0IB52OjQpDyu3xW6JmWFPW48rv27bhPq131fmvhvTFwjwT4TIWI+qhDRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CLmzPGdRp3Ba7Qv6cXtUtq47Hmy0aDVTWu8cjCazDH4=;
 b=RbYm+cObxVeWbNDONwiqmydqRtk+d+K0NbITG9jYEA/li5VMwLlkaR2cIBQxJHqTUSSjCBrAUl18f1/UJkcr0IGDuOl1wX9W4QJPd4juy+NAMhKqtn64/XRitJ5rGxHgS670RCu+x3LSgNSKHtfFMmBluoWBcZdTjuWIU+aXzVo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by PH8PR12MB6796.namprd12.prod.outlook.com (2603:10b6:510:1c7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.19; Wed, 16 Nov
 2022 10:28:18 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::395:21e6:abfd:7894]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::395:21e6:abfd:7894%6]) with mapi id 15.20.5813.018; Wed, 16 Nov 2022
 10:28:18 +0000
Message-ID: <db100e84-4adb-d661-fe1b-f6bb34247fa2@amd.com>
Date:   Wed, 16 Nov 2022 04:28:11 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH Part2 v6 14/49] crypto: ccp: Handle the legacy TMR
 allocation when SNP is enabled
Content-Language: en-US
To:     =?UTF-8?B?SE9SSUdVQ0hJIE5BT1lBKOWggOWPoyDnm7TkuZ8p?= 
        <naoya.horiguchi@nec.com>, Vlastimil Babka <vbabka@suse.cz>
Cc:     Borislav Petkov <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "jroedel@suse.de" <jroedel@suse.de>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "slp@redhat.com" <slp@redhat.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "srinivas.pandruvada@linux.intel.com" 
        <srinivas.pandruvada@linux.intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "dovmurik@linux.ibm.com" <dovmurik@linux.ibm.com>,
        "tobin@ibm.com" <tobin@ibm.com>,
        "michael.roth@amd.com" <michael.roth@amd.com>,
        "kirill@shutemov.name" <kirill@shutemov.name>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "marcorr@google.com" <marcorr@google.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "alpergun@google.com" <alpergun@google.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "Kaplan, David" <David.Kaplan@amd.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Oscar Salvador <osalvador@suse.de>
References: <3a51840f6a80c87b39632dc728dbd9b5dd444cd7.1655761627.git.ashish.kalra@amd.com>
 <Y0grhk1sq2tf/tUl@zn.tnic> <380c9748-1c86-4763-ea18-b884280a3b60@amd.com>
 <Y1e5oC9QyDlKpxZ9@zn.tnic> <6511c122-d5cc-3f8d-9651-7c2cd67dc5af@amd.com>
 <Y2A6/ZwvKhpNBTMP@zn.tnic> <dc89b2f4-1053-91ac-aeac-bb3b25f9ebc7@amd.com>
 <Y2JS7kn8Q9P4rXso@zn.tnic> <c2ce6317-aa51-2a2b-2d75-ad1fd269f3fa@amd.com>
 <7882353e-2b13-d35a-b462-cef35ee56f51@suse.cz>
 <20221116051920.GA821796@hori.linux.bs1.fc.nec.co.jp>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <20221116051920.GA821796@hori.linux.bs1.fc.nec.co.jp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1P222CA0005.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::10) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|PH8PR12MB6796:EE_
X-MS-Office365-Filtering-Correlation-Id: e16c5cd5-58c0-4241-c14c-08dac7bd4725
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b3RK196h/Z+YNhTYU6kUpiD6OhsUrpwVN6+4YYqjDJgl1C0MASBI98mqHw4l1w4yStAAdhykBKc13dJAfsMLvWMOdmFJ4ndlks/X5EnWRj12Sckbu40GFNU0toq1qkZT0oPd/IbQExGZVUGGuz+er/gUzQgIiW3UicQKg2mBpdPF53OdHQrfvbtgXj1YI6iIvAi/lPWxYEHh71W2EW0YTDg5+n6l8XStCLTHsqIvIWYlz64NrBsRxkyxSG4cOrfyaYyBEQkCFMt1tRV2WCV/vigLP1M9vBPbzs5JQbBna8bSHJmhowWqiDjOC5mzoT/28oma2lynJUi/YCvxSBhR/8qjQa4y5kynBKawP+uJPUjWCPUOA/Xepy3BoNOk+rAe7rGQEB7dchSO9pvjr2lMkC7c7IBILoLwyOmdvQ4ls+Gyw2CHX5LAyIBG4dDEhGAcUSvM4EVEgssuI79C+fKyr4vzUQfrp94b0SOcowJj/2S3SwOYdKlE1ktoYorG9/up7KLKC/5TlbT4bD2YztCFbsTGw99t5BIpLXJ/aW6GgzkIqGETvqm+dV7VfgRaJkPOGiw0J+Em+UfyCu2hHplErfdwcSeHIScJ4Nd45pAD5fEMEbcQZB4R0DNqudDhhem2BFKqVMHza3BmBrbfMwlEI103S6d4G5SV83SFgG+UAL7j34US2S+X0onRyDbC/RnocD5lxXv6VPepAhcrAJFzRgSpHoQvktDbrdqJMexYDyTS03TrEeyzNO222dMHAatVvEYEwE/9On7/h1p/w36hTk3uma8wNZqqLwKEYrwe5qJUVqVvq3laZ/pim29lXHI0CZ+/RZ/hNfDSnWdrZw2AsA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(376002)(136003)(346002)(39860400002)(451199015)(31696002)(86362001)(36756003)(41300700001)(2616005)(66476007)(66556008)(66946007)(8676002)(4326008)(110136005)(38100700002)(186003)(7406005)(7416002)(5660300002)(6666004)(45080400002)(8936002)(478600001)(966005)(6486002)(6512007)(316002)(26005)(54906003)(6506007)(53546011)(2906002)(31686004)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Skx5U1N4M0ZiVVpiNTEyZVZLdmVjOE5PcERjTVRieTdrVzZFLzhzT1lDWEds?=
 =?utf-8?B?QUVvcmk5ZkNwc1VYaVdVWW4yQWVNT2htUXl2eksyZXVyb3NINTNZd2tFanYv?=
 =?utf-8?B?N2lHL29WQ1dhcW9HblFvcUtoeU9DU1Z6Wkx3cTE3b3BBTmxseHViZG1RUTZv?=
 =?utf-8?B?Y014SU92Qzd2eXpGNWFFVUlBajZjTWpwa2VkamI1YkJrbVRaRlgweEZGb2lK?=
 =?utf-8?B?dEhCbENiTS9oODNtZ2dveUtyWWNuVXhVUWlyTFpmQVN6SjY3RVZ2WnhtdFRz?=
 =?utf-8?B?em9jdFRDVFp2N3Bzb01JcnNTUmY2OFpnVXRjUWdQQUQ2b1VsZHhPcUg1Qzcy?=
 =?utf-8?B?aW9NcnpmeStjbFU2UU01RXRNNVJKY1ZqRmluVVpvUUdxSjBTcXY5M0krYUla?=
 =?utf-8?B?RENlZndIVEk1LzUyZ21McWo0ZXgwVmZDWlpFWTdmVjZtZkJxYUd5UFdqaDYr?=
 =?utf-8?B?RDlFN05TOWRHS1ptUGFVSXZqNzhqZElua2JuSVRyV0FuNXdlSkxNUU5RRnVX?=
 =?utf-8?B?TzFZNVdaazRaZkc1TExYeU1NQ3RzczlrbHFRaUN2VVVrZ2F6TnJaOURIdy80?=
 =?utf-8?B?WUxOUnVMa2hpQnhNVW5POXpMeEw0RmdWc1Ixd2Q5NHJrVTEvWlZuSUMxY3pt?=
 =?utf-8?B?ZFk3T0luZ0pFNWNmR2xWQlpZZ0tndjNBb1ZmWTc2WWlkOUo4clZhdUE1S1Zi?=
 =?utf-8?B?QldWYnhPWkQzNXhoQnQ0T3pJOUhaVjNLaWdQbHFsMmtINmhUT2ticGNjQTVq?=
 =?utf-8?B?RE9hOUdvczdVbzk4QXIzM1RQck9tTTVMUUZzckFqakIrdmp3Ri94c1VVdHZr?=
 =?utf-8?B?M1UzcDRpRTZuTzJJNFRxblQyczE2K2ljcTBxdmE1bGdJZG1nL0ZMRHd6d2Jr?=
 =?utf-8?B?M2lTU3ZleEVqd1FQdkdGRHhWMkxyQkw3a1BQMmNzanFRNkhLd3hQMTh4OUYr?=
 =?utf-8?B?dG53eDhGT3dVcmRmYWR4djdVa3h3MEYxTjJlaUdHUm90Tmw4ekJtemthNUhp?=
 =?utf-8?B?UVBFa1hzdmRQMFNNUlAxbUZ1aW9GSzBzZW5yeFg4Y0xNR0xFWURDNUZQTGky?=
 =?utf-8?B?cjZLNVdaN0NiL0NmYUVQa2xSOUlBMjM4QkhySDJFZ1lMV2YrMzRGbytBdENk?=
 =?utf-8?B?bFJtTnJCdUk4QUNIRGppT1d3Wm5rS1hsNzFrYThSb01zODBPbVByRFBRZFdl?=
 =?utf-8?B?VmxVUDBPQkhOcHZITzF2eDF0SWZjZ25Xb3hHNDgyanFXazEyMExnV3pqV3dh?=
 =?utf-8?B?UU1veW5ab1Z4L2lyLzNjQXk2QThOdzJNRCtNOVFzMG5sQUJwTmdnRkJUclBZ?=
 =?utf-8?B?TnpqaWd3VlpZMmFoM0VyR29uM0pjMTV4UDZONE5ZV0pkTld3WGZQRWRDZXdi?=
 =?utf-8?B?S2RkekUrL1BQdmlWcTltendHRExmMHZRSlU5UWFIVW9SSG9hdWpUK0NXZitk?=
 =?utf-8?B?eUU0RUFiTFJPdzRMQWxOcjVTeGxnUTZwT1BidXVaZlJ4eHNjcE1zMHRIZ1oz?=
 =?utf-8?B?aHY1MnhNSEpYQm5udWdnV0ZnRjhnTU5hOElMbkFhRWZpUk5Tdnp5WmtYOGJL?=
 =?utf-8?B?ZzJFMFZFUXZuRHhwTGVtQU0ydTR6TjhHNlhWV2ZvT2Qxc2x0NERCZGVMVHV0?=
 =?utf-8?B?T2w4Vi9qZjI3VzZNWVIxMFlGbGxRLzBONGp5ZjluRGZYOTlCWmUzb2dTYktP?=
 =?utf-8?B?c3Q5RnM5MklsOUhnQjJFN1ZzMHJHTzJOUVpTa3lmaWEvTmpxdXNzQkVRaFhv?=
 =?utf-8?B?QUNQaDN1UU9Ob3lyU3JnOWN0WVY1LzI0eTJxQ2VBU05FMlY4N2ZFZEtCeDRt?=
 =?utf-8?B?QkZhNXBmaDJQaVplNkdWcERqWGNoYU9Jbmc4VisxQy9zTFJ2Zk42cGxtY0Ft?=
 =?utf-8?B?dGdIdmQzWjB2UGlvMVVGRTVld0ZCZkpkUW42YktKSE9OS1JCZ3NxSjJIL0xv?=
 =?utf-8?B?WWxBZmhWamlyTE1aeUpKQnptYVhzbmNYSTJ2bkY2a1hCZkE4WjhaVjdaeUpS?=
 =?utf-8?B?L2pjN2tTcjBsaTFON0NmK2lSZGVqUmd0aUZBcXMxTmFZZWo2eWd4MkJablA2?=
 =?utf-8?B?cVRBWmt3NlBscWJ5MGg3SmUwM2szV1hwQmFENWZ3WUNxcUdXcGVxemlMK1Nn?=
 =?utf-8?Q?2ugehehtB6Tvz7Y5BClsaELCr?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e16c5cd5-58c0-4241-c14c-08dac7bd4725
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 10:28:18.4311
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UtNcQTxXS7ucImvATba9jR+lpAD8fzlCMqf4Be7+JkyJ2SE4oD+jBbK998+Tj8lrrVXtIJkQDC+oMpTRwVx0CA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6796
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/15/2022 11:19 PM, HORIGUCHI NAOYA(堀口 直也) wrote:
> On Tue, Nov 15, 2022 at 04:14:42PM +0100, Vlastimil Babka wrote:
>> Cc'ing memory failure folks, the beinning of this subthread is here:
>>
>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fall%2F3a51840f6a80c87b39632dc728dbd9b5dd444cd7.1655761627.git.ashish.kalra%40amd.com%2F&amp;data=05%7C01%7Cashish.kalra%40amd.com%7C7b2d39d6e2504a8f923608dac792224b%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C638041727879125176%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=KBJLKhPQP23vmvY%2FNnbjZs8wTJs%2FrF%2BiU54Sdc4Ldx4%3D&amp;reserved=0
>>
>> On 11/15/22 00:36, Kalra, Ashish wrote:
>>> Hello Boris,
>>>
>>> On 11/2/2022 6:22 AM, Borislav Petkov wrote:
>>>> On Mon, Oct 31, 2022 at 04:58:38PM -0500, Kalra, Ashish wrote:
>>>>>        if (snp_lookup_rmpentry(pfn, &rmp_level)) {
>>>>>               do_sigbus(regs, error_code, address, VM_FAULT_SIGBUS);
>>>>>               return RMP_PF_RETRY;
>>>>
>>>> Does this issue some halfway understandable error message why the
>>>> process got killed?
>>>>
>>>>> Will look at adding our own recovery function for the same, but that will
>>>>> again mark the pages as poisoned, right ?
>>>>
>>>> Well, not poisoned but PG_offlimits or whatever the mm folks agree upon.
>>>> Semantically, it'll be handled the same way, ofc.
>>>
>>> Added a new PG_offlimits flag and a simple corresponding handler for it.
>>
>> One thing is, there's not enough page flags to be adding more (except
>> aliases for existing) for cases that can avoid it, but as Boris says, if
>> using alias to PG_hwpoison it depends what will become confused with the
>> actual hwpoison.
> 
> I agree with this. Just defining PG_offlimits as an alias of PG_hwpoison
> could break current hwpoison workload.  So if you finally decide to go
> forward in this direction, you may as well have some indicator to
> distinguish the new kind of leaked pages from hwpoisoned pages.
> 
> I don't remember exact thread, but I've read someone writing about similar
> kind of suggestion of using memory_failure() to make pages inaccessible in
> non-memory error usecase.  I feel that it could be possible to generalize
> memory_failure() as general-purpose page offlining (by renaming it with

But, doesn't memory_failure() also mark the pages as PG_hwpoison, and 
then using it for these leaked pages will again cause confusion with 
actual hwpoison ?

Thanks,
Ashish

> hard_offline_page() and making memory_failure() one of the user of it).
> 
> Thanks,
> Naoya Horiguchi
> 
