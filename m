Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D62C763E1B
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 20:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231858AbjGZSDc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 14:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbjGZSDb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 14:03:31 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2122.outbound.protection.outlook.com [40.107.22.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC6241988
        for <kvm@vger.kernel.org>; Wed, 26 Jul 2023 11:03:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gkmODdltE1IVsrk7Hlhc01on25G7IvE/HWxf1hos+zTAo08/rvnS0m1BzV3ch9WKf8AuEY4AnJ3oeFe6eo1yMDOkH5p89G6fGUsQ+uAUo2Y2DA/z0Tjvc/pxIitznZO0XYOpa0hzlyEkvmOdyX9NoqVNxIMpiKQFW17uSTia+OTxRApjHYUYOtqbnjtzRCpDIycL0oedkbLHVMN+tVPuHpw9fhlRTUYB7647b1uith/NQaLGYJYOldDHa3fytZS3ZUoL3vrS5OcTZlhC2IhkTaeHb+432cpUns4RHx9iC756e49KO4IwLT6D+zUUUYdfr4zk2V//HWW/bUmgiO9lIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jwh4EnaCTy9bIpYrhMmm0HtdG5irOlRsldvnJDrR9/s=;
 b=FGJq0mcs31umotCjB2EQd2n89rLraBXpXJfRgfpIBm1WKSG5oLMc3qBOEnvY4112CSwhCr2GQBi9Iv5Q9/d24g/NO3Jb7a2TgfM2aI8uvg1Ile7MMXSAJkqwUOU6RCvw19rV2RBy77hnqz7ymdcedjbR0/+bekNl7SyeHX7zGVC24aBvZeIFVlW5s4N1mvNDE/eoBnEaCZOyyDmd1CYfXqmACXQbtgVYtN/xXaDxmRKhxfUs+KNSfYWUZPjpGt5a4RE+baPfCwFQx2ETkrR/dHP05Ud4dgwlFYEzqk7ZTqR5sg+Nz6fNxBuTHko07HSKglXgDhyMZWMNcsMxzw9OgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=polito.it; dmarc=pass action=none header.from=polito.it;
 dkim=pass header.d=polito.it; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=politoit.onmicrosoft.com; s=selector2-politoit-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jwh4EnaCTy9bIpYrhMmm0HtdG5irOlRsldvnJDrR9/s=;
 b=VnWKXjXFsL+8KQaPGh7+GsvCXSxQzX9jj2Laqcc+pRJqcati2GVolOzGRfijSNPUMG/37wJrd6/m04J6rVaH/7Y4XgKAAGWKJp3fNIek/6ifoOscGh2oUOdD2RfnUsxzGMt+dwMXY2+EivJS1UGaolk6X9DoVV9vJm5C2oSGUQU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=polito.it;
Received: from AS5PR05MB10944.eurprd05.prod.outlook.com (2603:10a6:20b:673::5)
 by AM8PR05MB7921.eurprd05.prod.outlook.com (2603:10a6:20b:366::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.29; Wed, 26 Jul
 2023 18:03:26 +0000
Received: from AS5PR05MB10944.eurprd05.prod.outlook.com
 ([fe80::4730:8f0f:3286:a07b]) by AS5PR05MB10944.eurprd05.prod.outlook.com
 ([fe80::4730:8f0f:3286:a07b%7]) with mapi id 15.20.6609.032; Wed, 26 Jul 2023
 18:03:26 +0000
Message-ID: <56e34602-3fa1-cd95-a854-007b3276dbe4@polito.it>
Date:   Wed, 26 Jul 2023 11:03:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: Pre-populate TDP table to avoid page faults at VM boot
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
References: <65262e67-7885-971a-896d-ad9c0a760907@polito.it>
 <ZMFYhkSPE6Zbp8Ea@google.com>
Content-Language: en-US, it-IT
From:   Federico Parola <federico.parola@polito.it>
In-Reply-To: <ZMFYhkSPE6Zbp8Ea@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P220CA0014.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::19) To AS5PR05MB10944.eurprd05.prod.outlook.com
 (2603:10a6:20b:673::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS5PR05MB10944:EE_|AM8PR05MB7921:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b1794b1-db75-439e-6d57-08db8e029c15
X-POLITOEOL-test: CGP-Message-politoit
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D9QpXRv5SCColinMEmwDW4m95fn0hRlki+/t8dXDlmsD2BCEdoY11ONRePYnY9b9e8VpNftJngDLxwn96fhOGG83xeQcowyeTSJMlt/srWPGDnQ2bctb1ojsvKBOsM695JmJnJtRVbMf/k0lrEWoSa4UCSPas54iXL8FiQngCMqjboFf0wYUae2MxD9m5HH652c9GbwCwt9M+pIVjjWbcNfmHYClRE6i4AkK5ELZ2eMyYRROBY8QhTTGoT9JRBZoNQku9FK5mLwF9+zIHRQ/0IACVvSedHjwAT8XROed0si3YuXlmZ/4tZp3WPEjbQRqoKE6tDE5K0i8uWSBtWGTFF4O/QeA0X7Qzt+Um9IKPvzhHE9X3/OIWrkes5cNX3ck+AQThkqBcTRzYrAfGRi3sFvemVJ1Q6XqdpPhizE5Xkc+ZE9bUVP3dCEO+mriRGLAY7WY6pV1sTxJMhfXTKewqbVDpdJKdMgYLRMcxh8j6qPYUAm3FKxrF7HZNkIvPsDtPf3palG2igH6EuGHtJF43+qyrkrm1mUEeWVxb9D8TF6o4WoeVPvScQJJkooc0tJGJ371hLTcSIhPZEy7Tb6gxAAwaCex2pSJ3vOngeWtjG6EQWqYQ+hXsPFSm0hC/Nfu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS5PR05MB10944.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(346002)(396003)(366004)(376002)(451199021)(6666004)(6486002)(478600001)(83380400001)(53546011)(26005)(6506007)(6512007)(966005)(6916009)(4326008)(38100700002)(66476007)(66946007)(66556008)(186003)(31686004)(2616005)(44832011)(5660300002)(316002)(8676002)(8936002)(2906002)(41300700001)(786003)(86362001)(31696002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K2M4bkwvVC9HUlIvRzltU0Eyamt3Q3o1b09JQlNDTmNNT202bHA3OVI1SVpH?=
 =?utf-8?B?NHh4ajBJcFlhMVdGSS9OMzB6MEI0cnl5akdBUWhpbTE1R0VIS0NwVlNKK1RH?=
 =?utf-8?B?bVZNdUhHYzhpL2taVGUyUUtsTEMzUmNHRGdrUkZubis0VXY0QVpYL1ZTVVA5?=
 =?utf-8?B?czJzQXh3NWFLV25XRHphNXVJblQvVEdOV1pFelBqTENTQVlINXEzeHBCa2pZ?=
 =?utf-8?B?R1NDRllQK2t2MlZ5Njdob095Z1V6eDlOV0tESkZ4VzBrak8vZStGMFY1TWZK?=
 =?utf-8?B?R3BGUDkydWR3Y0ZxVndrYWNJUmR0aTNxeWpLNCt3WWE3cjBnMjZ0MkVlK2c2?=
 =?utf-8?B?bWtiNlZLREI0dFBUQ1ZkMFRNeEFxb05nYjNaRVZBRS9OTVJhd0YzOHBaUDFB?=
 =?utf-8?B?aVNwd2Nqd0wwcnhTbkZkdTA5cmw4NTV1ajBlcHFUeGNRNUtoa2QvZnEvOUtW?=
 =?utf-8?B?RUR4d0JLTnNwajZ5VjNHRFd0d2NSTURwY1hKbEoycDByOE03STV5TGJqZzZM?=
 =?utf-8?B?UVRMMm0xQStML1hmK2poRDZJUGxCOW9UeVNQQWRyMS9OR0Z2M2JIZEZPLy9N?=
 =?utf-8?B?ZXJHUkR6MEtWVXRhZUtzWVB6U3JuR05qbnhBSlhiaHI3YVZ2bEFsUWhRdnUr?=
 =?utf-8?B?MGlncmR3NnVJT0VBT2lsOWVTSnh4Uk1VeU1JS1VCWnU4VS9ndWFyUFJtUDlU?=
 =?utf-8?B?WE9rSElnbFM2Wm53VWJjT0o1SXNKbkFTcnFybFFtQVcrRi9yZnVsNUc5eGFj?=
 =?utf-8?B?M2pmMGpjNXE3aXg2Y00rQUJlWkZ2VkE4TVJKSmVra09oQ05YUzQ0TFM3SEJE?=
 =?utf-8?B?TXJXWmRvZWRqSEwvektGR1NwNjRHMGRUTTNMZzdyMzhHZCt2ZktTYVVVNXNM?=
 =?utf-8?B?OXg3MmhxQ0F2eGRLNzE2blRTZ0NKUU9IaXhYSDhMOGNSWjZFdkw5czhUSk81?=
 =?utf-8?B?N0VZaVlwMW5lNC9uYzF1c2JGQ1Z6RHVrMktJdnJWcWRiT250ejhlZUlIek9v?=
 =?utf-8?B?M1psWm9rN1VNeXhoNllUVCtwV2I5SFNpSHdpUXpyZE1vaEp4ZFBuK2x4bmZt?=
 =?utf-8?B?Zk16TktpOENXaTNIYkVvQkIzVk9GUlYyNlpJYllKNXpDU0ttTGZubG8yUmg2?=
 =?utf-8?B?cDBBZVdBaTkwWDZacCtFSjg0V09pQUtYbWwvMWxpSjJvNFo2VzFHSFR1QTVL?=
 =?utf-8?B?c2E5VGxKaytQM3NRazFuUUhBM0FJN2lhbmNYaHczckJuMDJKQ2RVSzRsYVNL?=
 =?utf-8?B?UDArVTd6OG1HQ1poU21KWnliem5oT3VOTFg2TklPUkUzS3N6Nk5hc2wzRXlp?=
 =?utf-8?B?enRpNENsZlYrZ2tLREplUm9SOG9JcHVURmpzZ2t3aDBDYnBLOUo3Nlc1UjJy?=
 =?utf-8?B?TU44Q21taWpkNHNvVEFCUFU3bEMzUFlqT1hJSTNtbVJpSXk3QVMyU2pYbW4r?=
 =?utf-8?B?QUZXQ1Z4SVJNL3ZSb0lGZy85K2s5aTE5TTlVZDBrS1N6M2EyUUdPU0pQckpD?=
 =?utf-8?B?Y1Zkc1hlb0cyRU9LbmRGWEhjejUxM3AvRERLMzNZSjU4Y3JRVGVVbXZUZ2Jp?=
 =?utf-8?B?Qk1GV0ppWmdBNkg1N0FuRlF0Yk9IRElCYUJ1ZWJibTZvRU4xSW1NOUk1a0k2?=
 =?utf-8?B?MXhhbVB5K3VTcld0M1lRWFBkM1pRRXhyN2EzMFpadGI1ellYZWQwL3BmNW9w?=
 =?utf-8?B?aWxvVGNueWwrZTczcEZKWTdVdndQZElXMi9aeTlmRW9pVmhJV29QUlhLOXRZ?=
 =?utf-8?B?TklKUkJjY1hCdm45SzJjV094Wm5OdkVjaTJvOWdMaGJIUlhNWXlWVWJucG5K?=
 =?utf-8?B?TktsTy9DUTg2aFRRZTdYQUpvc09YUEtxMTliWUhyUGY0eGtIK0hUMkNJNDFL?=
 =?utf-8?B?MjJ2cUlIaFh0WXlzK3hHYmdFbTRKZTErVlRySnpoVmpkUFpGZXhPdnMyT3gx?=
 =?utf-8?B?ajJFMCtSdGF0NjUyc1EyMkZnQzc4OXc4TjdCTTNpYWhndnc5dGxnSzNpMW1k?=
 =?utf-8?B?OGF1SEpMMllTUjRqUCtaOFlUUVNSWnErdkdqQ3pZTGhlUmpndmh4YWEwT2JI?=
 =?utf-8?B?L1Z2cUp5WWpoQlI2ZDN3L08rKzRXbU4zaDNZaEJaSzNrcWxZUXVuSHhvbHk0?=
 =?utf-8?B?NitFYmRmb01OUFltTDlzamZGM0xkTk5CVlllTnRlRnU0bEVzdG1TOG5BL0Z2?=
 =?utf-8?B?RWc9PQ==?=
X-OriginatorOrg: polito.it
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b1794b1-db75-439e-6d57-08db8e029c15
X-MS-Exchange-CrossTenant-AuthSource: AS5PR05MB10944.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2023 18:03:26.5426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2a05ac92-2049-4a26-9b34-897763efc8e2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3sn9Y/7EQ4G5chw6hLx1Q8A08OFEPPkCpoRapJ3P+yGVtYqENC+taQ459YIBogx7gdhhX9P5ghJ7MOSN+Bn4gt7XAPRIdWoWbCholV+HrVA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR05MB7921
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/26/23 10:31, Sean Christopherson wrote:
> On Wed, Jul 26, 2023, Federico Parola wrote:
>> Hi everyone,
>> is it possible to pre-populate the TDP table (EPT in my case) when
>> configuring the VM environment, so that there won't be a page fault / VM
>> exit every time the guest tries to access a RAM page for the first time?
> 
> No, not yet.
> 
>> At the moment I see a lot of page faults when the VM boots, is it possible
>> to prevent them to reduce boot time?
> 
> You can't currently prevent the page faults, but you can _significantly_ reduce
> them by backing guest memory with hugepages.  E.g. using 2MiB instead of 4KiB
> pages reduces the number of faults by 512x, and 1GiB (HugeTLB only) instead of
> 2MiB by another 512x.
> 
> But the word yet...
> 
> KVM needs to add internal APIs to allow userspace to tell to KVM map a particular
> GPA in order to support upcoming flavors of confidential VMs[1].  I could have
> sworn that I requested that that API be exposed to userspace via a common ioctl(),
> e.g. so that userspace can prefault all of guest memory if userspace is so inclined.
> Ah, I only made that comment in passing[2].
> 
> I'll follow-up in the TDX series to "officially" float the idea of exposing the
> helper as an ioctl().
> 
> [1] https://lkml.kernel.org/r/6a4c029af70d41b63bcee3d6a1f0c2377f6eb4bd.1690322424.git.isaku.yamahata%40intel.com
> [2] https://lore.kernel.org/all/ZGuh1J6AOw5v2R1W@google.com

Thank you very much for the prompt reply and useful tips. I'll keep an 
eye on the topic.

Best regards,
Federico Parola
