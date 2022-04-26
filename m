Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5CA50FC42
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 13:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349703AbiDZLyh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 07:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349682AbiDZLye (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 07:54:34 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DEF834B8C
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 04:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1650973885;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WrRgfXaYjt8gZOeXDhB5jtVUx00OXPWgnKLOyiunPfg=;
        b=d+5CErOdZNpfYUeqjJW5esUA0dBK5o+oczfnqcg/E+dxG+15G5+fyEKQkqMRmxWElDPZUo
        4681sk8vGjI9nI0VY6U1uqw942FMxqm7Bn46xrjjLlzBR+uzF+G2iW+W1oxVaqcsCZXfZP
        lDE/xk896gRuN+H8Fg32ijiS3+kEKSM=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2052.outbound.protection.outlook.com [104.47.13.52]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-11-9BO6sZ-AM6yh4mUyBvPAcA-1; Tue, 26 Apr 2022 13:51:23 +0200
X-MC-Unique: 9BO6sZ-AM6yh4mUyBvPAcA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lvOxo3xZNxmPnMJbQBJhqclVd2sgX2v1xD63K2RdQPtILAYN12WmfPSvVnjOg+Uc/JtOGdR4/SiffK/4DbXaBfNCvVk3+s3nmmZbuoszMreXog1po/rSs7n+0Ib6/4UGrwvXzo1zAgl1V8Qs4YCntkMck/cSsFZsoqE/JVROWW5a+WXwZszOXTppuoABzhR1S30I+RiFt2GdP0VbMorariz2rpOjmUh8j8P+Ph2c7ug71kkhmm8+CmJ8eFNEHFUDqOmq6ys91K1loYh2CmtmrctgEP+Gix5Dkqqf6ua1LJR1DKOQGBcKXNERw6aHjLOBa5lf6vQiq1u5U0/JjwG9EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WrRgfXaYjt8gZOeXDhB5jtVUx00OXPWgnKLOyiunPfg=;
 b=MsvoYro70L8XQG/0AwlOaKNejMRqoivcF7WzbKFd7wJCnTiOxlV9Uz4zXQ60dFAqPKq1inI+BuxRvX+zF86A8CUTjDrclnfYZ9+PISkmtUdQqjFpMPdFKe1Bir2btrT8ry7jJuPDpcaukUlB8Fh1frO/2OBG6w5+KnvKAWqHkEzI7NAlsPsJUGnD2/qo1JiYrlCO554FJdXfz0qIAPAgQ7oDJufvtfoOw53x9+W2aoApABEhu7XHWFVvOYdVHoTWr+sHd2tnNt7/6QBu2U7ZkiuxhMZddnSG1AVWWE/g5+gYwexNFLiV18jY0jzHolpXKqFBC+zCHIhOhN74dR2l0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AS1PR04MB9653.eurprd04.prod.outlook.com (2603:10a6:20b:475::14)
 by VI1PR0401MB2287.eurprd04.prod.outlook.com (2603:10a6:800:2e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.21; Tue, 26 Apr
 2022 11:51:21 +0000
Received: from AS1PR04MB9653.eurprd04.prod.outlook.com
 ([fe80::719c:bd0:8012:9a4f]) by AS1PR04MB9653.eurprd04.prod.outlook.com
 ([fe80::719c:bd0:8012:9a4f%5]) with mapi id 15.20.5186.020; Tue, 26 Apr 2022
 11:51:21 +0000
Subject: Re: [kvm-unit-tests PATCH v2 00/10] SMP Support for x86 UEFI Tests
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com,
        marcorr@google.com, zxwang42@gmail.com, erdemaktas@google.com,
        rientjes@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, jroedel@suse.de, bp@suse.de
References: <20220412173407.13637-1-varad.gautam@suse.com>
 <YlcrHyFqxKM4OQl7@google.com>
From:   Varad Gautam <varad.gautam@suse.com>
Message-ID: <c2351e58-3918-445b-c497-30d0d6ced4b5@suse.com>
Date:   Tue, 26 Apr 2022 13:51:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <YlcrHyFqxKM4OQl7@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS8PR04CA0180.eurprd04.prod.outlook.com
 (2603:10a6:20b:331::35) To AS1PR04MB9653.eurprd04.prod.outlook.com
 (2603:10a6:20b:475::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 623f527c-0828-49c8-558d-08da277b14b5
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2287:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0401MB228768417635C66740BB5B26E0FB9@VI1PR0401MB2287.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PQsahQ1hUUK0N+OUbzWIXZ5FG4VJ1n9yxzU4hO4qZhHEkro9wm6sHrS0FnYGgoHkF6CU/0iwhVOdry6QAEyh3sOg89Iez2tZ4NXe5TbaNPlukE4AoHT4MHFkAXxY/lUlLsK+Q5u5CPXCp62SJ4cqqt/PGyJzIG7VMPyAeNpTelDmgVaNKj6NfxeRpBJb6ylxTtPCtMZpzveifhdvp7v//ibDdIWNfTR4tc313KBgzuA57L4hngZx0b6OIE7Z8ykFnmwJ8dej9RQ9/wUpPk1tc8Q8oIDVuk9Y2KGTsCi7wIEbQ6bCuZxBlydjPqtyGo2Ia/PO43dAmSt+cP8av6IBxOkGe1uw5PushX6EXBGQA/zPhjdFV5SzBNxq6GgonftELbr5ZStI0cdpCdnnGczpLLWKnT2ul5NQnTkU/dMU8kHGRKcRmdGpyMU8SMkAbcx/AD+0ukuPDs5YIlPwcOo1Rov0dB0TyDB9WMoGcJvfcwv9qkJGLFv/375DFsWR5h697bUyxjGiM5R22nNHNXQtdElh/6FH/iqUHl8WyIWAXsGvb9apKYp8XzY9JF0vRgTE69ydS0VWegF5KxfVy2EEzK+Wy3lYhrFpZDDzdXO8RUGZROL5AA8RXIm4rnTXSJRPUuv+uiGQlQ9qwuNN73kBV76qJUUZi5apgAtumHGy/7vvTuYE2UfPZtJ/07TBBmPyupoeD/rhK713PaG+p39+tW0wgpr8A6FWeJEyhzjfYwkPp8MluNnwPFFQyNpeOFThdV4iy0BHfu/k9jy9TQMuPHgDRKrtUFY2/Jwr7ZEsiP9d+lXTp1XUlQlCIbb3r3DthLAylQpf43RhgSrqYngRxzN5W2h9TZXRNCj4TN0zIiM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS1PR04MB9653.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6916009)(6486002)(508600001)(53546011)(6506007)(31696002)(966005)(6666004)(2906002)(38100700002)(316002)(86362001)(31686004)(66556008)(66946007)(66476007)(4326008)(8676002)(186003)(2616005)(36756003)(7416002)(5660300002)(8936002)(26005)(6512007)(44832011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cTR2QktHMlZ2SFlxc1NQWUNEK2xxc3FuKzl6dTA3V0l3ZWVGbk9iZ0lLaFJl?=
 =?utf-8?B?RkFWbUZxYlltQ0VUeHJMdEZINTUwWkltSkV6Rm41RDc2ZzJoV2NSSEhYdmU0?=
 =?utf-8?B?dW1JOTI0MWxXQjJLK2E3RzZSTnJCS25GdnhBUHVuL2VPNFl2enZiMzFudHpj?=
 =?utf-8?B?QXYrcVpMMlRpUjlENmZWdlpZOWZjNnRaZlpMVG84TkpvVFFoaTFCcXZjZDZj?=
 =?utf-8?B?TStTNHN3WXE4L2I5YmI3R08xczJDUzYvaTVRNFo5aUQ5YlN0L2NHR2ozS1d6?=
 =?utf-8?B?TGI4Tk1rOEl3RDU3OXo3ek5xbkYzaHdicmFBY1FoUFllSFF2ZVZLWE1QSnFX?=
 =?utf-8?B?bXd5WUhvRDdaRTFYTlVIOHZrNWxVQmFJYzFNWWQ5eGlVMmV5dklLRDZPdGt0?=
 =?utf-8?B?RDRKV09ReE54TkwxazFMMGVVRTM4RnRBNDV1QTd5YTlWZkZMZFNnd05KQ2tL?=
 =?utf-8?B?enVLcnV0cVNRbDloYW1ibDVLZW5kV3JTYmE3ZmkvNFVNWFpQSkZ1K2syNTh5?=
 =?utf-8?B?bFgrQnFScStpb0xQL0FlQW9OQlRramVnSjFCMmszcHFOeHQ3V1dQM0IrdW5q?=
 =?utf-8?B?RVdlOVFXTEFFcGlDSW5LVlJtRXI2MXZEYkhocEJtcnQ4UFpiS2F0VDUvUjYw?=
 =?utf-8?B?SHEzcTFUandWaWgzRGlUT3VwS1pSTW1icDBkOUFqamxqRnRBdFI3cThuRlUw?=
 =?utf-8?B?SXJzYm1YRXpnRytLSHl5RW4zRWlYOVdXYU9MeU83UTBMSjE4REZkNTRiL1hw?=
 =?utf-8?B?eEtoMnFZMWJBTGNna0FsYmxiTjlLRlJDeVQ5cWNFVEV3VlpZNEhiOVk5cWJ3?=
 =?utf-8?B?ayswaEdrWGYzeGhLbUxpby9xVkJsV1ZVU0x3Q3lCT3dDM0JFVGRXTHYrZ0d0?=
 =?utf-8?B?SVNhR2F1Ri9XMEgveUE0Y3JKNmNhVXY0VE1KRVJxRGI2eWsxVFRhdGZjVnBT?=
 =?utf-8?B?WDA1enFxalhYZndQaEtxbjE5ek14UXVKRTAxV3h0Z0tabEhOd2VOc2doenY1?=
 =?utf-8?B?QTc5T2crTGROSGpFbHBGMkd4WkJ2THpsT3ZMRkR5VXhSWGI0cWEyTElRNWZp?=
 =?utf-8?B?MjhEY29uRjhuN3NaMmJYbG9IRmNEb0I3RjBla1dxRDFNMHBRTFo3aUE1UE8y?=
 =?utf-8?B?bUNJRTVhNkJ3TExXeW1seHRocDBOQXJuaTNwcjMzdGdIdFNMakhzOFJoS3FW?=
 =?utf-8?B?U0JTSHJZUjcyN1VxM1dLN0NPZkM3c00xUm02aDBkSEVrTkcvcEZTdGRLN1E5?=
 =?utf-8?B?SGRBNy9hMkdsbE5SYk1QNElzQjV1eVhrU2tTUUpIUjBxUDNOeFBJcHZGSXAw?=
 =?utf-8?B?cEpOWUo1a29uRHFEaXc1dWhFdHdCNFBYTXJlZThhRHBYeXZIVTl4T0pSUlRL?=
 =?utf-8?B?QmtRSDdndytCd3dWWVFJb3gxaTdKcGR6RFA1RnhnTVNUZ1kzTlBCKzE2aUtG?=
 =?utf-8?B?WUlzekhoUW9BNnFYbXNKVlk3NE9TU0RPS0Z0UVpnUXZMa1BpdmZidGltTkNz?=
 =?utf-8?B?aThLbDlPa01ZeUpWQmxmeHlCdWNNQmFQS2cxSE1JTUFOSFFiMU51UGwxZk5l?=
 =?utf-8?B?YVJUS2Z6Y3MxNnNxakpqRmlVeFRqbXpSck5nOWIvN1diWDEwdkJFNm1tZVJ6?=
 =?utf-8?B?YlMwMGk2U0JiWC8zZHVWNEV3MU53aVo2aGpwbUlVQVkydjE0c1Z6QjBVOWgv?=
 =?utf-8?B?azlWMEdLTTEvWjBKVDZoVURDWitJQ2R4VXJqdFYxY1p0bVFocU5tRk9uam1K?=
 =?utf-8?B?bDN6RG56c243aW9Id0FvZ3hobzJZTzl3ME5qeFNhRWZ5ejRtQUlTOVdnVWlS?=
 =?utf-8?B?L3dOUjRMYWxBTE1XUVdmVFhSZXhRaVlrYndBMmt0MDZZRDVOVjRpelZiYjdR?=
 =?utf-8?B?bGR4a1RpUUhRazFmeWRiTksyQ2tXYmFnK0xiOGJkSGs3T2hBU3RSMllOeWhz?=
 =?utf-8?B?UHBYY0RWSmpHdHJlT0RhZTlOQXl5clBhbU1MSnR1ZmUzZ25wZFJ4ZUdxanU4?=
 =?utf-8?B?d2hHNnExUG96a1lpOFJTdFo1SXU5a0NpWm14UlhUeUE1ZUwwRU11VXJlb05p?=
 =?utf-8?B?UXZ1TzlsUHJRa0hncjM1cGNoQWxQaVBQSmQzazhFK3VTUUFML1FpSXczcnhG?=
 =?utf-8?B?M2ZqUEVHUE9vUWVCTmdhQ1phVnY0a2s1YmNOLytYQk0zbE01M3BpNWZ6QUx6?=
 =?utf-8?B?SFRURGFaWkp3L29lNUVFRkwrSE9SWWNlYklzT1VqYVpyVjY5Q1Jka3ozMlNL?=
 =?utf-8?B?aDhlSE9ndkJQYkNXN1EvWFdIaTVteTVtVGxmbk9GUzBva0kxQTBFZjEyWlUx?=
 =?utf-8?B?YjBpVXVaY0p4Qm1ScmFYL3pqd0xyMW5mallmWTN1SFh5MWt0UHQ5QT09?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 623f527c-0828-49c8-558d-08da277b14b5
X-MS-Exchange-CrossTenant-AuthSource: AS1PR04MB9653.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2022 11:51:20.9953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FKYkpmXAhgjqtTWskMaLx4ERVc2vndZjtuZWwIA/xBX3fDZl+ZOIWUZR3UI6AIc1nfjBV7H/ZXY4rxHiUuXwEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2287
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/13/22 9:57 PM, Sean Christopherson wrote:
> On Tue, Apr 12, 2022, Varad Gautam wrote:
>> This series brings multi-vcpu support to UEFI tests on x86.
>>
>> Most of the necessary AP bringup code already exists within kvm-unit-tests'
>> cstart64.S, and has now been either rewritten in C or moved to a common location
>> to be shared between EFI and non-EFI test builds.
>>
>> A call gate is used to transition from 16-bit to 32-bit mode, since EFI may
>> not load the 32-bit entrypoint low enough to be reachable from the SIPI vector.
>>
>> Changes in v2:
>> - rebase onto kvm-unit-tests@1a4529ce83 + seanjc's percpu apic_ops series [1].
> 
> Thanks for taking on the rebase pain, I appreciate it!
> 
> Lots of comments, but mostly minor things to (hopefully) improve readability.  I
> belive the mixup with 32-bit targets is the only thing that might get painful.
> 

I've sent out a v3 at [1] taking in most of your comments. I've only left out the
changes to non-EFI 32-bit asm bringup code (x86/start32.S) and some renames which
I think would better go into a different series to keep this one easier to follow.

[1] https://lore.kernel.org/kvm/20220426114352.1262-1-varad.gautam@suse.com/

Thanks,
Varad

