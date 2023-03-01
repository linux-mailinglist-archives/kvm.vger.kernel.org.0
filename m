Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 828466A6A95
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 11:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbjCAKLA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 05:11:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbjCAKK4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 05:10:56 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2075.outbound.protection.outlook.com [40.107.244.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 849313B0E8
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 02:10:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kz7Tt26w3zRAIee5yJK4TLWgk9TbqKOrtM3/3WDVFm+KDcwOKgargLvoc/dH9IU0sGtNxISD2XzDHHv/pxh7ROGonQ4MSy50CMGi/ZuoQeaK1W3Nn0dyH04vuvhmSvLzUugLDMshJMe10KLuSXudg5rRgIPI35PVIexTrg3g3tzfzEQm3fb5ZC919sFJ+2T3CYRuJzkYE2yEvsff3gMercKA1WUnfOkmdxMvQRdXCzgsXKYtELmWTfPJz+57Miv25ki05f3a/zGjLVBnlVVs6ZNH4XLyOLyGXDlHWQrq5SQqGOZXp+Rlob9Fj4j7oSIGCYg7kCr+HHo4JdTMssZJoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SSQ5AHAXUVmbtkmY8twmm+0uSxd1bbgcFzP8o/cK2wQ=;
 b=hKnaBnL34/oKb7lGTQ22om3uS+70CAh20PnHh8b893hm2L5k0GnwJbLtHOZsluZ9BoBBuocapZze4yAMXE2hqF6WLHbPOnziCngKJS6iLLm5DNQEeIO4j//8LW5DOi8s75aKVvKX4IsZlXXpO8MIEk3GqLRi/DQVf0S90gqZn5CNUKldgJgUy7QdzMtGrl6SbVNt1GuregZlfmQU1mvSWydS544sxihHpmB6ryxw4N8CpkFP2it66ecpmzsMSx5SSPHkdcOGu7GusHT4sjLtlYSoE+GfxbaW2ddsbWBOkS/EL5+RY6D1HhU905RUaWU2YIMUS83HN/ZiKMW56uvV8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SSQ5AHAXUVmbtkmY8twmm+0uSxd1bbgcFzP8o/cK2wQ=;
 b=t9RF/zqDlzXBGGttLYUYtIpO01Tfb7DqoFiZ6cK/1SfUpx6Rf6gjaT8lQBkm/PgK200VSNNjFd0CJ2czxbmu295DT9nlGmS0agMXA7fyRiS3kumDaIZMRSpmBmEiroQZcyvJvg3WW6EpPmO08KK2OgdCOFHnIm4A/9nu97gh17+XKlaDZi9p9eVGYNRTQ1zs055l9JZKlqZoI3CKAlx495bMiw19IHVgfAJK4chUVg6dP1cDQgBrD6jfk4G9wFk9ZoLhOcA6vzBBFV3s5I2zf8hytTJuHxKwMLTnaMwzwWaa3sb8cufM1g7gHZm7bxdj76MQ7FlFDfuGzasm1/dYiw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BN9PR12MB5305.namprd12.prod.outlook.com (2603:10b6:408:102::5)
 by SA0PR12MB4542.namprd12.prod.outlook.com (2603:10b6:806:73::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.18; Wed, 1 Mar
 2023 10:10:45 +0000
Received: from BN9PR12MB5305.namprd12.prod.outlook.com
 ([fe80::8cf7:f3ff:8738:49f0]) by BN9PR12MB5305.namprd12.prod.outlook.com
 ([fe80::8cf7:f3ff:8738:49f0%3]) with mapi id 15.20.6156.018; Wed, 1 Mar 2023
 10:10:45 +0000
Message-ID: <de78ffc1-430f-7eb9-938f-af5c4ed27ea0@nvidia.com>
Date:   Wed, 1 Mar 2023 15:40:34 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: Bug: Completion-Wait loop timed out with vfio
Content-Language: en-US
To:     Tasos Sahanidis <tasos@tasossah.com>, alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org
References: <a01fa87d-bd42-e108-606b-78759edcecf8@tasossah.com>
 <bcc9d355-b464-7eaf-238c-e95d2f65c93d@nvidia.com>
 <31c2caf4-57b2-be1a-cf15-146903f7b2a1@tasossah.com>
X-Nvconfidentiality: public
From:   Abhishek Sahu <abhsahu@nvidia.com>
In-Reply-To: <31c2caf4-57b2-be1a-cf15-146903f7b2a1@tasossah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA0PR01CA0008.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:80::15) To BN9PR12MB5305.namprd12.prod.outlook.com
 (2603:10b6:408:102::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5305:EE_|SA0PR12MB4542:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cf1945b-b1c8-4e81-77bb-08db1a3d38d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vuO9E3lyaEqkfAaQ7C6F45zf65EO1Rcwrdkzv11hXd5w0tAd6P1CfltcWoBwyljZ4IkHBJFS6z3+zy66kwx9oQps1UpcgcmX+Fhfd46q3dWj4Klo7QPdiCf9cUFVd6UioHXFMm6vpt7vFBZEenXW1gDwAWLjBkd/3zRfJnoSYur6aK0nQc9DYbtG9EQvBC4Q18U3qUc1PwJ0sZqr+iCHDUN0oUaaAERT7Noox6R/drSkD1rHYGxS1Gs2JUeJC+FD5kLbnebspeeAOgff8LbepOG/spzu1HIdseKyElk/XWssNQDkIbSRJVc0OfLGvpWJNYQqm1gp5JgBGbNn/sWcKXwW5RaJIulk+ffkaPXZE4ALdnMm/4e+/acL/RaqjfE14ZJ2JRS00zBZPYK/esTYPdz2SH26jnLKPmqC6mT+WzDarYILaqitFTlDNdiWAgAGstvkUq/R3V+Kk84zFbiwV4RsrGBMxR9odFuuepqlLMRtnDR2PdQpyd/2J+ebP17GQ6+MmqdkdkWPY7VVqbUsY1Z1mFXKvoD16CBTW6Vs4HxfE8Ii77Y6BalNj0db6uMBbfTKzMNlwWe+STD10VltoMatknwQ12zrMz7Go++f/3OHijKoCEfXxcCtRZ4MtOD8ytLGcik2FTkzIrneXlTgq4TyU57Z/rxXmUsOgdrZ/XNvdZHJKGp/af8iSv05uLXUzx6+6Gi4CHJYxj7FtUE2A8eI5Sf8MwSzJn2TMk/JyD0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5305.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(376002)(39860400002)(136003)(366004)(451199018)(36756003)(53546011)(6512007)(6506007)(6666004)(6486002)(66946007)(66556008)(66476007)(4326008)(8676002)(478600001)(83380400001)(316002)(2906002)(86362001)(5660300002)(30864003)(31696002)(26005)(186003)(38100700002)(2616005)(8936002)(41300700001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MmkxZUltYWZVNWVyajBUNFhaUVhGejR0b3hMcCtEOFdVZXVlYnJheEhFQTJu?=
 =?utf-8?B?V1BJbklsdmRISXhLUVg3YTJlamxpOWR0V2NESE1OTU1FekcwakxDdUxSQm5Q?=
 =?utf-8?B?RGN2dlc4MFpkL01aY21DU0U1SXZvK2tQMFhxMnhNQmpSUlNueFdnd0Nqb1pj?=
 =?utf-8?B?a3hzWWZlU3l6cWNZeitsRFZSakdMUlh6cDkwbXlKOS9oTlFmM3BVL2V0MjYx?=
 =?utf-8?B?cmJ5cTN6RjFqaXhmekVnWmRKZXZyeFhCRE5CcGRPQ2kydzBxdkRtbkh6RWdm?=
 =?utf-8?B?OGUyRWZaUXk5cFFUSmVObmI0MGx6Zm9QNmZsL3ZXdjdLSDA5R3BST2tjbGVn?=
 =?utf-8?B?a2F2U29LaFR1aE51RkZXdnBENGtLWUpRdXpoMGZtaE96c2t2WW1ibkZzM0U1?=
 =?utf-8?B?T3NMcHhvUEFOM3I2cmZMZHM0WkFPNEhXUzlQbUZGYURXMWdRZytYWTFEVjUv?=
 =?utf-8?B?SFA4RUFvZkE4RjZiYlhSbEZqRUtkcGlSTGl6cnpyRTRhd3NyY2ppRnlFbFJK?=
 =?utf-8?B?VStROVZONVZvYmRSN041ZWpGQmNRUHZDUlRZQ2FEa25RSWExRFAxVkUvUCsy?=
 =?utf-8?B?VjJTTGNXMlJ6TW5lZlliNVIzOGlXLzJveTRFMkxBUjJVZ29aTXhNaXB0Y2pP?=
 =?utf-8?B?MVFUOUxGc0Z2Vk5XaDJBUXE3Z2VUN0o1RWcwV2VKbVNGdTF2aEZHMTNrOXBU?=
 =?utf-8?B?ZFJvYU9zVjJvbjRsZWI2dzI3K3Q5TVlNZHJCSUZkR0tCdTN5VXRiTkx5RFIw?=
 =?utf-8?B?V2hjODFYSjhtS0pkSHRQQUl3d0ZGdTBiRGkwQXNMTUI0ZVNpRXFZTzlOcDhp?=
 =?utf-8?B?YzRYSkJ4d1FLaTFLOFBqdjlGNlhuZi8rS1NkNUZkYlBSckYwYlBlOWpuV2dU?=
 =?utf-8?B?elNYcEdtaGpFT1Z0WUhlMXlvbWhlYVQ4TVhjRzVQQXNiQXlXQ2sxQ3pFNW9a?=
 =?utf-8?B?RmNpNW1MUnRqaHZNb2ozQzRueU5pcmYrOHdsRjNBMkU2blhlaE5aam82RmRU?=
 =?utf-8?B?cFIyWDU2bHpiTU5MNzd6YWtwRVluVG5mRjNMRm5PRlphSkE0SlNLdHBFcUx4?=
 =?utf-8?B?OERiMHhINEpmWlNFbVhYNGMwRzY5RjNFMVAxVE9qb0k1elJkZ0N1QXh4ZmtH?=
 =?utf-8?B?Z0E1TTRSdXkyWmljak9VUGZxbkl0aktXTERZaldXc082QzgyS2xkWU9QT3Rv?=
 =?utf-8?B?Y2JxSjZjZzJML0t3b0JlcHRRL0pNWkk0Vk9zZXEzY0NFZE1hM2pBNld2NWlY?=
 =?utf-8?B?K2djWEN5N01UVzJVU0VGTU9lbGVPR1hHdVU3b29aQms2Ymg2c2l5c0tlVitY?=
 =?utf-8?B?c2ZoRnI5STdMeWxQeGdIRTBGdEN5cFBsRy9kVmxNbTVpb24xV1dZVXk4NGRC?=
 =?utf-8?B?Uk1nQUJWRHNCMzNhNk1iMUtzUWlIZUJhUnJuVFFRcUxFeU16NjUzQVNURy9v?=
 =?utf-8?B?aFpwMFZRdTRPYkt5QXY1dlltaEkvQlFjNVpCTWNZQmNTTlZWNU1JRkVVSURK?=
 =?utf-8?B?cGpFVGUrdjVTNVM1UWxGZ3MyVW9ZVmZ5L0xtRFN5czdoYmRrMjFEOTdQWEpD?=
 =?utf-8?B?bk1aUngxblF4Q1JRNGRrQm9wRFhUOU1TU1pISDkydkpDdkVLVU9mZnVsZXVC?=
 =?utf-8?B?d28zMGFKL0p2ZW0wWVU5Qmozb0dyWUVWRTF5VmZaRERsMEVqaHcwUFlEYVRR?=
 =?utf-8?B?NVhDd0tMaFBEOXFhV0tEbndqbVVyQ0YzYkx5a0JhTElLeTRjUnV5dXp0OFpn?=
 =?utf-8?B?M0VxektiWmdSYkxpckpMdFBlM09mNW1NeFIrQWYxVmQ0Q0I3S0phSC9PK0ZX?=
 =?utf-8?B?WXAyUlZCeFdaTWZ0Tk9CS2cwalQ2cEdMbkZ3QUNMSnZPU0d2THNvdXlyNUpZ?=
 =?utf-8?B?a0QxK2ZLZXJlQXNEd3lyVXJqWnRsSFM4L3NnT2VDUjNGQ2dxcDBSYmQwWHBv?=
 =?utf-8?B?Zk10cm8vTVFhY05GMlR0Qytwa01LeXVuVmEvT2ozVmNXeis2OXRFeUg2T3Rs?=
 =?utf-8?B?WndXNHg2MHU3NWNXZ0pIcWhKL2RGL1hINS85NE5aMWcydVRMVWVGL2N0cWJP?=
 =?utf-8?B?M3RjQ00rQUduTkxuT2pxUkE0REVXcmw2ODlRSitKbFlXWTdsb1Vla2txeDNq?=
 =?utf-8?Q?WR2eZ+ZvlXKaAfE2W6q1Gg6nQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cf1945b-b1c8-4e81-77bb-08db1a3d38d9
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5305.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2023 10:10:45.6222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qjCf74Pe4sqwFGJLVzVlk6NH9+cw/nQBqFXK63vhlph2WWG0hTQIicgT94Mmj3YWF/CG/1ZLNl99NFGf94P6+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4542
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/28/2023 1:03 PM, Tasos Sahanidis wrote:
> Thank you very much for your quick response, Abhishek.
> 
>> 1. Set disable_idle_d3 module parameter set and check if this issue happens.
> The issue does not happen with disable_idle_d3, which means I can at
> least now use newer kernels. All the following commands were ran
> *without* disable_idle_d3, so that the issue would occur.
> 
>> 2. Without starting the VM, check the status of following sysfs entries.
> I assume by /sys/bus/pci/devices/<B:D:F>/power/power_state you meant
> /sys/bus/pci/devices/<B:D:F>/power_state, as the former doesn't exist.
> 
> # cat /sys/bus/pci/devices/0000\:06\:00.0/power/runtime_status
> suspended
> # cat /sys/bus/pci/devices/0000\:06\:00.0/power_state
> D3hot
> 

 So D3cold is not supported on this system.
 Most of the desktop systems doesn’t support D3cold. 
 In that case, as Alex mentioned that after that patch the root port can also
 go into D3hot state.
 
 Another difference is that earlier we were changing the device power state by
 directly writing into PCI PM_CTRL registers. Now, we are using kernel generic
 runtime PM function to perform the same.

 We need to print the root port runtime status and power_state as Alex mentioned.

 Apart from that, can we try following things to get more information,

 Before binding the Device to vfio-pci driver, disable the runtime power
 management of the root port
 
 # echo on > /sys/bus/pci/devices/<root_port B:D:F>/power/control

 After this, bind the device to vfio-pci driver and check the runtime status and power_state
 for both device and root port. The root port runtime_status should be active and power_state
 should be D0.

 With the runtime PM disabled for the root port, check if this issue happens.
 It will give clue if the root port going into D3hot status is causing the issue or
 the use of runtime PM to put device into D3hot is causing this. 

>> 3. After issue happens, run the above command again.
> This is with the VM running and the errors in dmesg:
> 
> # cat /sys/bus/pci/devices/0000\:06\:00.0/power/runtime_status
> active
> # cat /sys/bus/pci/devices/0000\:06\:00.0/power_state
> D0
> 
>> 4. Do lspci -s <B:D:F> -vvv without starting the VM and see if it is printing the correct
>>    results and there is no new prints in the dmesg.
> This is from before the VM was started:
> 
> # lspci -s 0000:06:00.0 -vvv
> 06:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] Bonaire XT [Radeon HD 7790/8770 / R7 360 / R9 260/360 OEM] (prog-if 00 [VGA controller])
> 	Subsystem: ASUSTeK Computer Inc. Radeon HD 7790 DirectCU II OC
> 	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Interrupt: pin A routed to IRQ 255
> 	Region 0: Memory at <ignored> (64-bit, prefetchable) [disabled]
> 	Region 2: Memory at <ignored> (64-bit, prefetchable) [disabled]
> 	Region 4: I/O ports at d000 [disabled] [size=256]
> 	Region 5: Memory at fca00000 (32-bit, non-prefetchable) [disabled] [size=256K]
> 	Expansion ROM at fca40000 [disabled] [size=128K]
> 	Capabilities: [48] Vendor Specific Information: Len=08 <?>
> 	Capabilities: [50] Power Management version 3
> 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1+,D2+,D3hot+,D3cold-)
> 		Status: D3 NoSoftRst+ PME-Enable+ DSel=0 DScale=0 PME-
> 	Capabilities: [58] Express (v2) Legacy Endpoint, MSI 00
> 		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
> 			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
> 		DevCtl:	CorrErr+ NonFatalErr+ FatalErr+ UnsupReq+
> 			RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
> 			MaxPayload 128 bytes, MaxReadReq 512 bytes
> 		DevSta:	CorrErr+ NonFatalErr- FatalErr- UnsupReq+ AuxPwr- TransPend-
> 		LnkCap:	Port #2, Speed 8GT/s, Width x16, ASPM L0s L1, Exit Latency L0s <64ns, L1 <1us
> 			ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp+
> 		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- CommClk+
> 			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> 		LnkSta:	Speed 8GT/s (ok), Width x4 (downgraded)
> 			TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
> 		DevCap2: Completion Timeout: Not Supported, TimeoutDis-, NROPrPrP-, LTR-
> 			 10BitTagComp-, 10BitTagReq-, OBFF Not Supported, ExtFmt+, EETLPPrefix+, MaxEETLPPrefixes 1
> 			 EmergencyPowerReduction Not Supported, EmergencyPowerReductionInit-
> 			 FRS-
> 			 AtomicOpsCap: 32bit- 64bit- 128bitCAS-
> 		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled
> 			 AtomicOpsCtl: ReqEn-
> 		LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- SpeedDis-
> 			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
> 			 Compliance De-emphasis: -6dB
> 		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete+, EqualizationPhase1+
> 			 EqualizationPhase2+, EqualizationPhase3+, LinkEqualizationRequest-
> 	Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
> 		Address: 0000000000000000  Data: 0000
> 	Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
> 	Capabilities: [150 v2] Advanced Error Reporting
> 		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
> 		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
> 		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
> 		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr-
> 		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr+
> 		AERCap:	First Error Pointer: 00, ECRCGenCap+ ECRCGenEn- ECRCChkCap+ ECRCChkEn-
> 			MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
> 		HeaderLog: 00000000 00000000 00000000 00000000
> 	Capabilities: [270 v1] Secondary PCI Express
> 		LnkCtl3: LnkEquIntrruptEn-, PerformEqu-
> 		LaneErrStat: 0
> 	Capabilities: [2b0 v1] Address Translation Service (ATS)
> 		ATSCap:	Invalidate Queue Depth: 00
> 		ATSCtl:	Enable+, Smallest Translation Unit: 00
> 	Capabilities: [2c0 v1] Page Request Interface (PRI)
> 		PRICtl: Enable- Reset-
> 		PRISta: RF- UPRGI- Stopped+
> 		Page Request Capacity: 00000020, Page Request Allocation: 00000000
> 	Capabilities: [2d0 v1] Process Address Space ID (PASID)
> 		PASIDCap: Exec+ Priv+, Max PASID Width: 10
> 		PASIDCtl: Enable- Exec- Priv-
> 	Kernel driver in use: vfio-pci
> 	Kernel modules: amdgpu
> 
> 
> This is the diff from while the VM was running:
> 
> @@ -1,25 +1,25 @@
>  root@tasos-Standard-PC-Q35-ICH9-2009:~# lspci -s 0000:06:00.0 -vvv
>  06:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] Bonaire XT [Radeon HD 7790/8770 / R7 360 / R9 260/360 OEM] (prog-if 00 [VGA controller])
>  	Subsystem: ASUSTeK Computer Inc. Radeon HD 7790 DirectCU II OC
> -	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> +	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
>  	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> -	Interrupt: pin A routed to IRQ 255
> -	Region 0: Memory at <ignored> (64-bit, prefetchable) [disabled]
> -	Region 2: Memory at <ignored> (64-bit, prefetchable) [disabled]
> -	Region 4: I/O ports at d000 [disabled] [size=256]
> -	Region 5: Memory at fca00000 (32-bit, non-prefetchable) [disabled] [size=256K]
> +	Interrupt: pin A routed to IRQ 42
> +	Region 0: Memory at <ignored> (64-bit, prefetchable)
> +	Region 2: Memory at <ignored> (64-bit, prefetchable)
> +	Region 4: I/O ports at d000 [size=256]
> +	Region 5: Memory at fca00000 (32-bit, non-prefetchable) [size=256K]
>  	Expansion ROM at fca40000 [disabled] [size=128K]
>  	Capabilities: [48] Vendor Specific Information: Len=08 <?>
>  	Capabilities: [50] Power Management version 3
>  		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1+,D2+,D3hot+,D3cold-)
> -		Status: D3 NoSoftRst+ PME-Enable+ DSel=0 DScale=0 PME-
> +		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
>  	Capabilities: [58] Express (v2) Legacy Endpoint, MSI 00
>  		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
>  			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
>  		DevCtl:	CorrErr+ NonFatalErr+ FatalErr+ UnsupReq+
>  			RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
>  			MaxPayload 128 bytes, MaxReadReq 512 bytes
> -		DevSta:	CorrErr+ NonFatalErr- FatalErr- UnsupReq+ AuxPwr- TransPend-
> +		DevSta:	CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr- TransPend-
>  		LnkCap:	Port #2, Speed 8GT/s, Width x16, ASPM L0s L1, Exit Latency L0s <64ns, L1 <1us
>  			ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp+
>  		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- CommClk+
> 
> 
> If I am reading this correctly, the card claims to not support D3cold.
> 
> Nothing extra was printed in dmesg while running the lspci commands.
> 
> Regarding the "Memory at <ignored> (64-bit, prefetchable)" lines, this
> is because of presumably a firmware bug where it doesn't correctly map
> the secondary graphics card in the address space.
> 
> On my main installation, I boot with pci=realloc which fixes it, but due
> to the filesystem corruption risk, I am performing this testing on a
> separate installation with the rest of the drives unmounted, and I
> forgot to add pci=realloc. The behaviour in regards to the power
> management issue is the same in both cases (it was originally discovered
> with pci=realloc set).
> 

 This  “Completion-Wait loop timed out with vfio” prints is coming
 from the IOMMU driver. Can you please check once by adding ‘pci=realloc’
 in your separate installation and see if we the memory are enabled after
 D3hot cycles. If memory is getting disabled only after D3hot cycles with
 ‘pci=realloc’, then we need to find out at which stage it is happening
 (when the device is going into D3hot or when root port is going into D3hot).

 For this we can disable the runtime PM of both device and root port before
 binding the device to vfio-pci driver. Then enable runtime PM of device first
 and wait for it to go into suspended state. Then check lspci output. 
 Then enable the same for root port and check lspci output.

>> 5. Enable the ftrace events related with runtime power management before starting the VM
> I captured the trace, but
> $ wc -l trace
> 41129 trace
> 
> It doesn't sound like a good idea to send the contents of that entire
> file. Is there something specific you'd like me to filter for?
> 
> Perhaps this is a bit better?:
> $ grep "KVM\|qemu\|0000:06:00" trace | wc -l
> 719
> 
> If not, I can upload the entire file and send a link, although I don't
> know if it will be caught in a spam filter.
> 

 Mainly I was looking for the prints related with the device, root port
 and any other device present under the root port (like audio function of the GPU).
 But given these logs are huge and won’t help much here so you can skip this.

 Thanks,
 Abhishek

>>  6. Do you have any NVIDIA graphics card with you. If you have, then
>>     could you please check if issue happens with that.
> Unfortunately, no, I do not have any NVIDIA cards.
> 
> I tried passing through a:
> 0a:00.0 Serial controller [0700]: MosChip Semiconductor Technology Ltd. PCIe 9912 Multi-I/O Controller [9710:9912] (prog-if 02 [16550])
> which claims:
> 	Capabilities: [78] Power Management version 3
> 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
> 		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
> 
> and I did not get any messages/errors in dmesg.
> 
> Thank you
> 
> --
> Tasos
> 

