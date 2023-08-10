Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECDF776EE8
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 06:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231801AbjHJEHU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 00:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbjHJEHQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 00:07:16 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2065.outbound.protection.outlook.com [40.107.92.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76F0611F;
        Wed,  9 Aug 2023 21:07:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WjOi9htfdIULFPVXCcCy4wmvNioEurabq7/3M4sVunHMw1NJJkJ36M0URK2FEpkuMv9p86Ch8QnHHV1EpjYh8qOp7UZx7WK7D5vvCUkKXqe52xzQ3cYychm7Xvhn3xIUx5KWvfODIzjQsUJ9qXzRI/9dmoTKbSPKsl8Z/oJNJk4A1T/uQqmEaBu/pA5XDF9R/JgSYBm077ndPpl5dCPY4EGj3uYdR+hZ8c5HVdVV+gBA2A+7G6zlILIvBgDVm+DgQp/g/g+yfBOjPVrqrxLjmCRUKjg6UxjpBJ+hYu7oxnH0d4lLuQVifYTDygIKAj0qevIc59aT092DZ5ox1X06iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tjVBg9GEL4QFF2WywGJ6DOo5b6ycPxQVoNDbHL8CGmw=;
 b=cYjV7a53gtyN5TfBtIswy6wD8z/nHWjN5rpBx/oLPgdeakiZbqvjyfhkcCaXbuz6pfz0qtEyRRktWJesxopmlVBFYXhUZugLOP5yMaN7TIDccH/PtWdC61WB0D9MJdZGmDNUesSB+kK73ZZTFYeg3B7IyrJOz6BgZ55GPFyZo4VBrz+3+JyRzlKYCmgywEvKs1TV7BGiuFwL9Uc7SpafV0RT3797Hg7As80hTDKz56vR5LS6JC4a0eMMEe6A4mKuXWdiXzyygPTOTBknu85Kn7X4h7sTmeGp9ik7I9zO1I3xvkghBSwiKOj7L668+yd7Lzbh9rysnskZDwFBtcnvyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tjVBg9GEL4QFF2WywGJ6DOo5b6ycPxQVoNDbHL8CGmw=;
 b=E6BgqYPYOSNHITTeH5053ULizcvHgrli918Er2yz3d7zEOOVCUW21I1CKBbEFB/M5SE1gDWV9RO1zMYS+CHZagVdXtNVE9PkJfpmWiTBcattpEVtE3WOBqP5rukp/nPfqR09Hxbr7vHcqJuZB60qecb4CPKB7DDfjbXhxfl63N8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB6460.namprd12.prod.outlook.com (2603:10b6:208:3a8::13)
 by SA1PR12MB9004.namprd12.prod.outlook.com (2603:10b6:806:388::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.30; Thu, 10 Aug
 2023 04:07:12 +0000
Received: from IA1PR12MB6460.namprd12.prod.outlook.com
 ([fe80::ee82:d062:ad1f:ddcd]) by IA1PR12MB6460.namprd12.prod.outlook.com
 ([fe80::ee82:d062:ad1f:ddcd%6]) with mapi id 15.20.6652.029; Thu, 10 Aug 2023
 04:07:11 +0000
Message-ID: <de474347-122d-54cd-eabf-9dcc95ab9eae@amd.com>
Date:   Thu, 10 Aug 2023 09:36:59 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
X-Mozilla-News-Host: news://54.189.247.149:119
Content-Language: en-US
To:     kvm@vger.kernel.org, linux-next@vger.kernel.org
From:   "Aithal, Srikanth" <sraithal@amd.com>
Subject: next-20230809: kvm unittest fail: emulator
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BM1P287CA0011.INDP287.PROD.OUTLOOK.COM
 (2603:1096:b00:40::15) To IA1PR12MB6460.namprd12.prod.outlook.com
 (2603:10b6:208:3a8::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB6460:EE_|SA1PR12MB9004:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b0418d9-7a1a-4811-ebf8-08db995745cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IfuebOa9iq6/2CuyY3MXg4ljI6hE2kg3u1kIl84yQ0TPJJaLx+Rxp/D8KFkZAEcHK1gjH6c7LuUK7NLjIEUukr+EP/hDGyayJ74gmFM9DxPZKEZPc5E66wWGE/urZRZPig+SBy/CR12Tw9d67ZfNNXuhUwgf86LQcxYLIkWXLTyfbzYYn7LQ2PE8Hpy3prtA+LFrvw7Y/A03Xx90OkeZ5UpaO+7c5+v/7ereiyGfYNCSd4h0mpzlIc0cPC5uHVz6qBm2Wtsu3JKGG4HdDsaArDUT3cn8fSorrZU2N5KvWbfcEWHBqOAYXi3oM2UZV/0dvoqYJvLS+ScpjN1z7uWfe+8t92zzJJHO7Qw20b3JnRjtHy6uugs7dJ0onyuDa7N9S/LJI2Z6tIvvvOPN//ijSGIIg+mkAKGyFNeVrmEbzFBNhyC5CqZ+E/ZfVOlqkyXl6j0Z4aTzi3sKENXQqtA7DooOUXAdqKycOfQCp1A3zUEUOqPQud/zvn9K3pqYBd9QKLoy3dE3umQJ1nXLfn1p07egA+DpOvoH//D8nr91qSM+12OrcfXJ86BAl6XwCVkamVGYdz82eJwxLtsAqUJq7CuOzaeymW/S0xkSfyrrI+6dxZYOPOHaSjaPGQFrt/etMsJ2Wr6CL/nuGLSV8l6C0Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6460.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(396003)(346002)(136003)(39860400002)(451199021)(186006)(1800799006)(6486002)(2906002)(31696002)(19627235002)(2616005)(478600001)(6666004)(38100700002)(316002)(5660300002)(6506007)(26005)(36756003)(6512007)(41300700001)(8936002)(8676002)(31686004)(966005)(66476007)(66556008)(450100002)(66946007)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TEpDWXlDeG4rL240TzZUbmtEaUxsSnN4dzNYc2VBRXRTdDY0S0ZJM1A3eVVR?=
 =?utf-8?B?V1RsK3NXcWxRODNETHVEeGR6MVp4VmZZbmxIemtjN0hNVEQ1YmZiaEYzTFRh?=
 =?utf-8?B?bmIraE91cXhKSDBlbG9GZFI3STJHcStuRGRUOXhXSy8ybDYxNENoS3Jra2to?=
 =?utf-8?B?UTBhdS90RkorYkhUdGlKRDZ4S1Nia3JnRlF1RjNQbWVMVUNQRWlTS29mb1ZN?=
 =?utf-8?B?ZkJoK3NQVWlCS1hXb3BzUFJFNWNEYi96NGgzaFVTb2hBWU8wZmw5cWZPdFJl?=
 =?utf-8?B?ZnpwajgzcVZzUjVuMExDb2dKMURyZnFkbDFmZXdtSlBleG41ZG1tdUdENzVE?=
 =?utf-8?B?dG8vK2JQbHNsM05DR3FMUHRLbktPUnlSME45SDFOR0l4QWsrb1J3YXBCZk1w?=
 =?utf-8?B?YnZPNS9Ua2JOWkV6S0U4OEF3VlhvRHpNTCtlZ25rY3hNKzBBSU5TVU9oMTZE?=
 =?utf-8?B?d284aWFvazFoRWlNMjdKNDVDVGFoNCtIalBjRGU5OU9PVndUVmV5ZDgyL1N5?=
 =?utf-8?B?bGVOaDNySVlGQ05ST2pqRC90VnNKUWh4RlJ4Wmd1bkdJekJrK053OVIrT3pR?=
 =?utf-8?B?c01SaDRJTlpiSkY2Wng5MWQxc2lCdVp5R1JTUk9NTDJUV3lIbm96UUttVThW?=
 =?utf-8?B?VFVrZjN0ajlHSjdETzJ3aytBa3FBa2crYldRMW52NDdOdVJxd1VzQm9tWmhG?=
 =?utf-8?B?bXJpR0RmcTNBSTlTWnV3QnlGdXdtNGppVldPTGQ1enNSWnZyVmgrNWZuTjZT?=
 =?utf-8?B?Ri9HZmJVSHF4K1VhWHBRN0hRRDZhZjdDOEJaMUpVQVBMb0x0d2ZidkFHS3N3?=
 =?utf-8?B?SnBkcldvWTRyeTR2TitVVUVQVVBmUzBWeUtXelZsL0tEMlFPVFY2KzNtZ0hl?=
 =?utf-8?B?QnluOFZBMGJHdnlyVHF3WGp3aWd0UzJ5U0lYNXRza2JiYlFtdWd3SUthWkNp?=
 =?utf-8?B?RUZpdmNJaGFiUm8ySXlSaVVQWlloSDhKSEkyN3J1NmYzQWhuRzF0VGJ6S3hC?=
 =?utf-8?B?MHpIZU0vNDRaQXBGa0FJUndjQ3lhSUxGeit6ZGxTSlB3b2hGK3lDd0tDM1o2?=
 =?utf-8?B?VDBDVGQyOUNiSzZXVFhMdmF0U2tZSXFid0NvRzdNRGRqN244MXJYbzNGU1I5?=
 =?utf-8?B?TCs4eTJyVnZkN2NRb0R3TXlYNmlYaCtHd3ZodXVvSTlRTVZHdUYyeTlzZjZ1?=
 =?utf-8?B?YU9zb3hxTGRSY3dIQjVkb3paVjM5SzQ0b3FXcE9GdnQ2N1R0UmJhMkJ3cHVG?=
 =?utf-8?B?TmRpenVxbk4xMThDZGhyT1hWSWVaTW9GVVRKS0xxblc2eHRHZEZ5NHdWYUEy?=
 =?utf-8?B?UWo4UU5FeHAvN3hpbVRGeEpCcjFWMEpoenlUaTNuNXZ5Ky9Vd05OZU13WG9D?=
 =?utf-8?B?czE0NlJCRFhpWUV1WFNHSHh1RG1iYVh2VzBNYWg1OGtyYWt5SHhWKzdZMHhU?=
 =?utf-8?B?dnRXNFVJV2VSUkRRSkdCSExvTzVlRnVFQVdSaHhXT2loQjNlekIxMVlVYjNO?=
 =?utf-8?B?WDd6Z05rZ05yTERPOFMvWTl0d0lKU2NwMGZ5bkU3cE1rbVhCNElZbW9HYXJh?=
 =?utf-8?B?NjJ4d2xNVFZlWm5yRlBpNC9VUWVzWCtZZWpkZUd5MEQ3S2lRQTVFQTZJSys5?=
 =?utf-8?B?ekRIMmtrTXNxcWVLUmRWekVvTjRveXVoTkdrbzJ4MVZoeW43YTlUVlpkS0FW?=
 =?utf-8?B?VUVXQ1kvNklvKzNCbmFaYmMzeGluNHJjam1UNmt5T1FKdWFOUkwyVXM3bUJh?=
 =?utf-8?B?N2tkYUE4cEg4V0NFenBXS2EyV3hiS0Z6eWxvaVFGT0JyUXRFT000RUhWRkVy?=
 =?utf-8?B?dmpScElTTXRrVm9zbEg3NHBmeVJvd1htUmRVV050aVU3eE5XcTE4bzNrS0cz?=
 =?utf-8?B?a1hGMlRXVGJDbE5ZdllHc1poWXlSUGkwYitPS1phZ3U5N2dHd0pFYmJsd2FD?=
 =?utf-8?B?MXFjSHcvZXE1UVVkNjRFQzdiV1MwSW5DM1NpdXFTT3k2dU5KeGdraEM4d1Bt?=
 =?utf-8?B?QjRwOW5BaTQyb085alpuYUpsZ0d5NDRsekdBYlhtTzZRUjlXU1pUSkZCbXB3?=
 =?utf-8?B?QmZCQm5HakJ5MTVQdmUwQVYyTng5aGNiWHV4c1hwMkdIMmtPWHZDQjJLdzJZ?=
 =?utf-8?Q?Son4tgMtsKeEMi+Mqlb+m5Utt?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b0418d9-7a1a-4811-ebf8-08db995745cb
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6460.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2023 04:07:11.9225
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HvUNA7yM11Bb1MVODR3b5I/2Ht38mdqdCBfMjtvD3x0yHeiPb/r2Vs8i+SM4fZXISF3W9TaJZeBg6nHeB5ZxGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB9004
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

On linux-next 20230809 build kvm emulator unittest failed.

===================
Recreation steps:
===================

1. git clone https://gitlab.com/kvm-unit-tests/kvm-unit-tests.git
2. export QEMU=<location of QEMU binary> I used v8.0.2
3. cd kvm-unit-tests/;./configure;make standalone;tests/emulator

Debug log:

[stdout] BUILD_HEAD=023002d2
[stdout] timeout -k 1s --foreground 90s 
/home/VT_BUILD/qemu/build/x86_64-softmmu/qemu-system-x86_64 --no-reboot 
-nodefaults -device pc-testdev -device 
isa-debug-exit,iobase=0xf4,iosize=0x4 -vnc none -serial stdio -device 
pci-testdev -machine accel=kvm -kernel /tmp/tmp.AFoESgjELO -smp 1 # 
-initrd /tmp/tmp.CGpwyvgHI4
[stdout] enabling apic
[stdout] smp: waiting for 0 APs
[stdout] SKIP: Skipping tests the require forced emulation, use 
kvm.force_emulation_prefix=1 to enable
[stdout] paging enabled
[stdout] cr0 = 80010011
[stdout] cr3 = 1007000
[stdout] cr4 = 20
[stdout] PASS: mov reg, r/m (1)
[stdout] FAIL: or
[stdout] FAIL: add
[stdout] FAIL: xor
[stdout] FAIL: sub
[stdout] FAIL: adc(0)
[stdout] FAIL: adc(0)
[stdout] FAIL: sbb(0)
[stdout] FAIL: sbb(1)
[stdout] FAIL: and
[stdout] FAIL: test
[stdout] FAIL: repe/cmpsb (1)
[stdout] FAIL: repe cmpsb (1.zf)
[stdout] FAIL: repe cmpsw (1)
[stdout] FAIL: repe cmpll (1)
[stdout] FAIL: repe cmpsq (1)
[stdout] FAIL: repe cmpsb (2)
[stdout] FAIL: repe cmpsw (2)
[stdout] FAIL: repe cmpll (2)
[stdout] FAIL: repe cmpsq (2)
[stdout] FAIL: repe/cmpsb (1)
[stdout] FAIL: repe cmpsb (1.zf)
[stdout] FAIL: repe cmpsw (1)
[stdout] FAIL: repe cmpll (1)
[stdout] FAIL: repe cmpsq (1)
[stdout] FAIL: repe cmpsb (2)
[stdout] FAIL: repe cmpsw (2)
[stdout] FAIL: repe cmpll (2)
[stdout] FAIL: repe cmpsq (2)
[stdout] FAIL: scasb match
[stdout] PASS: scasb mismatch
[stdout] FAIL: scasw match
[stdout] PASS: scasw mismatch
[stdout] FAIL: scasd match
[stdout] PASS: scasd mismatch
[stdout] FAIL: scasq match
[stdout] PASS: scasq mismatch
[stdout] PASS: smsw (1)
[stdout] PASS: smsw (2)
[stdout] PASS: smsw (3)
[stdout] before 80010011 after 80010019
[stdout] PASS: lmsw (1)
[stdout] before 80010011 after 80010011
[stdout] PASS: lmsw (2)
[stdout] PASS: lmsw (3)
[stdout] PASS: outsb up
[stdout] PASS: outsb down
[stdout] FAIL: incl
[stdout] FAIL: decl
[stdout] FAIL: incb
[stdout] FAIL: decb
[stdout] FAIL: lock incl
[stdout] FAIL: lock decl
[stdout] FAIL: lock incb
[stdout] FAIL: lock decb
[stdout] FAIL: lock negl
[stdout] FAIL: lock notl
[stdout] FAIL: lock negb
[stdout] FAIL: lock notb
[stdout] FAIL: btcl imm8, r/m
[stdout] FAIL: btcl reg, r/m
[stdout] FAIL: btcq reg, r/m
[stdout] PASS: bsfw r/m, reg
[stdout] PASS: bsfl r/m, reg
[stdout] PASS: bsfq r/m, reg
[stdout] FAIL: bsfq r/m, reg
[stdout] PASS: bsrw r/m, reg
[stdout] PASS: bsrl r/m, reg
[stdout] PASS: bsrq r/m, reg
[stdout] FAIL: bsrq r/m, reg
[stdout] PASS: imul ax, mem
[stdout] PASS: imul eax, mem
[stdout] PASS: imul ax, mem, imm8
[stdout] PASS: imul eax, mem, imm8
[stdout] PASS: imul ax, mem, imm
[stdout] PASS: imul eax, mem, imm
[stdout] PASS: imul rax, mem
[stdout] PASS: imul rax, mem, imm8
[stdout] PASS: imul rax, mem, imm
[stdout] PASS: movdqu (read)
[stdout] PASS: movdqu (write)
[stdout] PASS: movaps (read)
[stdout] PASS: movaps (write)
[stdout] PASS: movapd (read)
[stdout] PASS: movapd (write)
[stdout] PASS: movups (read)
[stdout] PASS: movups (write)
[stdout] PASS: movupd (read)
[stdout] PASS: movupd (write)
[stdout] PASS: movups unaligned
[stdout] PASS: movupd unaligned
[stdout] PASS: unaligned movaps exception
[stdout] PASS: movups unaligned crosspage
[stdout] PASS: movups crosspage exception
[stdout] FAIL: shld (cl)
[stdout] FAIL: shrd (cl)
[stdout] PASS: ltr
[stdout] PASS: cross-page mmio read
[stdout] PASS: cross-page mmio write
[stdout] PASS: string_io_mmio
[stdout] SKIP: MOVBE unsupported by CPU
[stdout] PASS: no fep: #DB occurred after MOV SS
[stdout] FAIL: push $imm8
[stdout] FAIL: push %reg
[stdout] FAIL: push mem
[stdout] FAIL: push $imm
[stdout] FAIL: pop mem
[stdout] PASS: pop mem (2)
[stdout] PASS: pop reg
[stdout] PASS: ret
[stdout] PASS: leave
[stdout] FAIL: enter
[stdout] FAIL: xchg reg, r/m (1)
[stdout] FAIL: xchg reg, r/m (2)
[stdout] FAIL: xchg reg, r/m (3)
[stdout] FAIL: xchg reg, r/m (4)
[stdout] FAIL: xadd reg, r/m (1)
[stdout] FAIL: xadd reg, r/m (2)
[stdout] FAIL: xadd reg, r/m (3)
[stdout] FAIL: xadd reg, r/m (4)
[stdout] PASS: mov %cr8
[stdout] PASS: ljmp
[stdout] PASS: divq (fault)
[stdout] PASS: divq (1)
[stdout] PASS: mulb mem
[stdout] PASS: mulw mem
[stdout] PASS: mull mem
[stdout] PASS: mulq mem
[stdout] FAIL: movq (mmx, read)
[stdout] PASS: movq (mmx, write)
[stdout] FAIL: movb $imm, 0(%rip)
[stdout] PASS: Test ret/iret with a nullified segment
[stdout] PASS: mov null, %ss
[stdout] PASS: mov null, %ss (with ss.rpl != cpl)
[stdout] FAIL: cmovnel
[stdout] PASS: push16
[stdout] PASS: jump to non-canonical address
[stdout] SUMMARY: 136 tests, 68 unexpected failures, 2 skipped
[stdout] [31mFAIL[0m emulator (136 tests, 68 unexpected failures, 2 
skipped)
