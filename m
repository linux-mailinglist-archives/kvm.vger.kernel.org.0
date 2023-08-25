Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACFC0789069
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 23:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbjHYVcV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 17:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbjHYVbq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 17:31:46 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2050.outbound.protection.outlook.com [40.107.101.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 543BC10C7;
        Fri, 25 Aug 2023 14:31:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hRORNbbLJOxXdvhI3Gj3xg+hwF196Cq1+vgDwHmu3vV25Tq5N5K+R815R+IEClQlNSp4WC5+gLc7VYlRXfhtIeR+qaayiefa7Q3JFgwjrvLB79DFuC1kkWauf1caL1+NNorIxy0qDiB9hvixURo4WH8i6bZvMJORjG63seDQPv8ytEIldwZWyMY9S6/qtglvF0TvWswSn0K2tpXdKeMB2xPAjeKH80xpejBoIz5TpK7IIWsbOhU2tL5z73hcnj062mCWIYbRfocdzJm5CujF6dxazvVP0bjDpq3U+7cHcVS+ozF25Jk31sQwxis5bhv/92CuJUf3jzkvjHXmuL2XuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7aKoolh+8QWPkBs7DqBdq4gXNd9LAJoLWlwmsel5V2c=;
 b=SLDXZzQnqRep3jYR3uTm6Ssz9K7hd1sWN6gpLT9yXLMzJAnopfLr03E/UG3GKExNSsw7yMa1uq3YeTBlUZH/S15QEVQ+N/cux15mU+a1428+s4p+YkBtkdEnmfMjRhu4bUsDzwWg3VK+LfTiHdrVAN2k5fFn/WG+20bBG1tIEuVuheaYT6/UOew6yXdBU9WxfCGGcwhGR3cF7tYW5Zs/GbLjHGEAaoceXXSqJJVHvRuJCWQDceH7/NUjy4xFiHLyuYGix+DZdACSuhUV2J/uPb1qItrdPlPDCN8INUsNqtR9w8sU17jwU/2sJf2s5c3rVFFqo6Pxl5zpCjHTkg0+mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7aKoolh+8QWPkBs7DqBdq4gXNd9LAJoLWlwmsel5V2c=;
 b=14lchlBy705Mz8702Xfi/Q4j8oeE4rvxJAFG0c88hxPlp3At1a5POc72MQTKDs94RNPLh0InUiAADGWOqJ57eNp0sX8o4y4AX2txse1VIJspuFDiAbK/2VWVa+T5yG1xF7lnD5g3O0PlGKiiev+2gGCwOGKBFueqv3KwUgUOADs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by IA0PR12MB7722.namprd12.prod.outlook.com (2603:10b6:208:432::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.27; Fri, 25 Aug
 2023 21:31:38 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd%7]) with mapi id 15.20.6699.028; Fri, 25 Aug 2023
 21:31:38 +0000
Message-ID: <740dc02c-4cb7-c578-18fd-02d90b21ffc8@amd.com>
Date:   Fri, 25 Aug 2023 16:31:35 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2 0/4] KVM: SVM: Fix unexpected #UD on INT3 in SEV guests
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wu Zongyo <wuzongyo@mail.ustc.edu.cn>
References: <20230825013621.2845700-1-seanjc@google.com>
 <169297925407.2870848.7136723526525176171.b4-ty@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <169297925407.2870848.7136723526525176171.b4-ty@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0154.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::9) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|IA0PR12MB7722:EE_
X-MS-Office365-Filtering-Correlation-Id: cc394a69-0aac-4b93-6a08-08dba5b2aa45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yEWhANdOpbqaEYuj8FDFMD9NIMtOKj9tnZTjkeI2VB6TDntO/oYOOMVV60P2vIgD6z6AJQibFKKMZDD0M08q0SHMPsUI09s7U9Fzb1nMpwaRAqlkYf8yyN2agRag6S3z/tV3CyXejXbzKmnlncEhAPIg2t75bnPSQgQDR7kYQupxUxBVKZHQuaID5lKdSpu/DhYmYo37MabydgzGRzUNoYZWeRqdv3p/lPQsv9z0mVrLL6Fg883wAwKCeH3OZ6VYehOu9xBeGVfX4ZG9m6LEdgYwjjNsRann8nDiGdZmpuaTTOrenYtK6QpVgERS1z4r12JExOi/nO46AV1Yn093uLLJsx1tOWB+B8aOSt2n9JBJ5LiXb/9bSJd48d3rfnG33Adb2yHjQsBYMyYCNjq1AizF0xJSrqrCrobN4mBvZ5s4z2gL0uDI1dEvQbgGWR0uxUkDky54AnLUvgdXByQ5yQVvRnFeiZybCiagf61l+Edv70enhk6+z6BMezl/3y4zrqj+xmYRexQ+fwwdOxUJHNfTyvzaj4J5Ea7Fz6DES+D2qspMr/l4MXlpx03FNdJynZsmEPskXHSnTUWxDR9y3HBwCAqYTcL/BoAcY5ubaTtInpLIA6uC41g716MHvHs6IYRGK/zFpfcRUFmoUOX1GmYc7wszlk6+PhjZyGIuyojhH3DqRk40F4NoS3uWOAqi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(136003)(366004)(39860400002)(376002)(186009)(1800799009)(451199024)(2616005)(83380400001)(8676002)(8936002)(4326008)(5660300002)(36756003)(26005)(6666004)(38100700002)(66946007)(66476007)(66556008)(316002)(110136005)(478600001)(966005)(31686004)(41300700001)(6512007)(2906002)(6486002)(6506007)(53546011)(86362001)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SUk0YzNaWnlYTXRiZEZDeHYxR2l5eWFGVk1EcHc3NG5hcldQTkJsdUthY3FK?=
 =?utf-8?B?Nmd1dHdVMnpXT0Q0ZW9ZZGxMTWI3TXcwTVRTRTZQenJJcWJrcHluUWNlWlpJ?=
 =?utf-8?B?K1Y4QitkSkVhbHdnMGZ5YXNlZ1hzMnNOUEg5Y1Q4c2Y2UVQ5NTEyM2dTa3hj?=
 =?utf-8?B?YlBEQ1QxT1ZlYmNqMHJrSjNEL0tYMGFTTThWUzhDYktmZ01ibXVHalR5NEt5?=
 =?utf-8?B?TWtEckhMNitMdlVWM1VOK3lkcjFMZm96TzVUYkdveDVJUWovb1NYUXF0N2py?=
 =?utf-8?B?TmVPdVpyTktqbjJ0bnMrR2VaTERwTFpDNnJLUFZDRWZzTmV3U0ovc2hOczdO?=
 =?utf-8?B?aDlhNzhmU2FGcjA1VzMxZzh5TXhhVEkyN3NXbjA4dUw5WXZYTzhGcU42anpU?=
 =?utf-8?B?bkZZY1RweW05ekk4dmpLTCtPWmwyK0dRWW92b0UrZUhaQzJHV0FhTm9oVHVS?=
 =?utf-8?B?WENGODVELzNuRVJ4bzdHeDJOUWxSa2lQZFpRRjgydEp0ajVPZE9lVERzc2xQ?=
 =?utf-8?B?aUxQMDZnMnRlTkJpTXQ5L2hCOU95MkI3Qk4xYjdia1FtcWhRZUZ3clN3UjBl?=
 =?utf-8?B?MzZETElwclpJTWMvd09lekkvaDd0QXRpSzltWjBXRTMvcEgxcDcyckd2bklQ?=
 =?utf-8?B?ZERWcFhQSDZPaElURFRTSTR0MVZEWTVFaVk5VTVON1p3RmUyZDFWaE1JSzZr?=
 =?utf-8?B?NUVaWHVVT2Nibk9QKzh3VWVKNWhMbWprRGFUU3B0bWluMExGMzdtc2w4OEZv?=
 =?utf-8?B?YmJSN1VvSzdlRmNUdzhvbnNGcGR4Sk10TlBXZlAyb3VCWll5MjNMa29WcGhS?=
 =?utf-8?B?NHZGa1EwOEpDNTFRMHhMQTJ0ZDZSNjhBWVBTWEpFUExEaG5raUh1M2pFT3FQ?=
 =?utf-8?B?MTJnbzkrRDQ5Y2p3eWIrNWgveFhmNXRiY09rd3BCZnJ0VkRnbXp5MmpIemRB?=
 =?utf-8?B?L20rZHBlSkhwYUFJNkU4MVVvUTZXZzdFUDdrbURxK3drV2ZxekVudTJMaEc0?=
 =?utf-8?B?TTRRaE1nbXpCYVJ4M0VzTHQ0dnNESzhsZWhoYXpuUjBvRVVKWFZKclFKU3ZU?=
 =?utf-8?B?VURvUlg3ckEzVnkzdWFXTUFRc2hDSE1hVFNEcmlWWWNmWTgrRy85MGN2MEVU?=
 =?utf-8?B?SWtVRmFob2swVUZZMVcwbnF0ZzBIVWZFd0YzRzJWZTM5MWtZblZGSktpWUJl?=
 =?utf-8?B?Q3BJU0RiMzJ6MFpBVjk1Wm9MbUdsUnh2TmR1ZG5JL0orMFF0OWtieVdlYTF6?=
 =?utf-8?B?dEhRRUIrL0pWZGtWajF0bWsxa3NUS1NBZldJMWtZOWZVMzdzdGo1WUg2bnYw?=
 =?utf-8?B?ZVZEUmxiWmZwOXBwKzU5L29jT21Va3JUczRMU2ZiemlWNEUzSllyOC8rSVVi?=
 =?utf-8?B?QnhOTWlKSEJHV2tIWmdjcGRXK0xrYWM0T2xKVDhXa0tBckZ4OE1ndzJzdFlv?=
 =?utf-8?B?c1hFRGZTaWlSNm93TG5NdHZ6M3k3VW5mYmtLMzhkN3VVZGlma3J1RVB3ek15?=
 =?utf-8?B?UTlCS3RFb1JoaEwrNnplaGJhVEEyQmFQOUpEQmtzYjNmWHliUDB4dXk2TjZs?=
 =?utf-8?B?WnIvSm1NV0ZpeEJjNER6c0Y1VXVjcTFoOXNHanVrVGFTUDJoWi9INUtmVTB2?=
 =?utf-8?B?QkNzcjNjSE15OXZkWWhSY3NuUEl3Y0FoTWlSS3QzaHUwRjZ3OWVqeTV1WnRj?=
 =?utf-8?B?OUw3MEtweitQNFdjTkw5Q3JQaGt5bithQ2htYzUxUnVxSHlWVjE4WWttRW5i?=
 =?utf-8?B?ekhkTW9OY2RIK0xubFV0NkgwUndxS2Q1NzFWd0N1L3VZZHF2aDJ4Smp1NlFJ?=
 =?utf-8?B?cnZWdVk1M1dLanJmYUpNZEl6U3U2ZC8vanMvODNWcUdwV2VZRDlXVVVSdzJQ?=
 =?utf-8?B?WnVYNmpyZDlFdSt3dVloVjExeDVlaUNMSnM2MzI4OGt5bExBZzZCR1dhQWFi?=
 =?utf-8?B?Uk1KMGlpYWJuZ29MV0IySnVCc25OM05RdEo2UFZyRFNOR0p5OXEwcnNVYW5J?=
 =?utf-8?B?aG1SRnNwRXBVbEtGN0x0MWxUbEFYNEVFTDUyK3VueURCa0V6c3FWZ0tDMUVn?=
 =?utf-8?B?U2Q5Z3BBTDlOWjg5K2k1OFNsMUt2TFp3eVc1SVJON2JSR1d1Z2poUnVmZXl1?=
 =?utf-8?Q?itGLWbsQDU2iP/nd5DkMKnn1G?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc394a69-0aac-4b93-6a08-08dba5b2aa45
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2023 21:31:38.4058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u5D2mQ1NrIp3ODXkYEq+R74ZJGhCHvN/tJUXkqaEMBDapClxjdIpkRbj2tenymlWSToXceegYs9qAlVmqoAwjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7722
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/25/23 14:02, Sean Christopherson wrote:
> On Thu, 24 Aug 2023 18:36:17 -0700, Sean Christopherson wrote:
>> Fix a bug where KVM injects a bogus #UD for SEV guests when trying to skip
>> an INT3 as part of re-injecting the associated #BP that got kinda sorta
>> intercepted due to a #NPF occuring while vectoring/delivering the #BP.
>>
>> Patch 1 is the main fix.  It's a little ugly, but suitable for backporting.
>>
>> Patch 2 is a tangentially related cleanup to make NRIPS a requirement for
>> enabling SEV, e.g. so that we don't ever get "bug" reports of SEV guests
>> not working when NRIPS is disabled.
>>
>> [...]
> 
> Applied 1 and 2 to kvm-x86 svm, the more aggressive cleanup can definitely wait
> until 6.7.
> 
> [1/4] KVM: SVM: Don't inject #UD if KVM attempts to skip SEV guest insn
>        https://github.com/kvm-x86/linux/commit/cb49631ad111
> [2/4] KVM: SVM: Require nrips support for SEV guests (and beyond)
>        https://github.com/kvm-x86/linux/commit/80d0f521d59e

Thanks, Sean!

I'm taking it through our testing and will let know if anything pops up. 
Since you have a recreate I don't expect anything, though.

Thanks,
Tom

> 
> --
> https://github.com/kvm-x86/linux/tree/next
> https://github.com/kvm-x86/linux/tree/fixes
