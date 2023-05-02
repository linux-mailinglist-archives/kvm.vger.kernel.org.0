Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 001A96F4D60
	for <lists+kvm@lfdr.de>; Wed,  3 May 2023 01:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjEBXEH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 May 2023 19:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjEBXEG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 May 2023 19:04:06 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2060.outbound.protection.outlook.com [40.107.93.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5E672D44
        for <kvm@vger.kernel.org>; Tue,  2 May 2023 16:04:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G9GU5IyO/Mv5Hr25LOX0Mg9kRzRb8qMR/Q/xQfyrKLKB6O3n5VgN6kJBEZWpSgaltVNVMibcN2aocgOMak5SOmxiDKROGnhlZGxnL4yEFUjDYKkiklHKfcmQ5x26RJNaNinSXVa+Sb4h7QOG2ffwFDymarJpTCPwnOH+AacLOo7mw6D0AnIrrcyRVQzSx1G8x2hNuHz6IAVxkn6Ttung33XMAyDvVhgWQqkiHN01vdzIDZJDJHML84QVQ56IfFNFaLVr58kn2FRWfGntIPc2ou6Hso1BaHqWlSF/Etr1R+0XKp1NE5RUvi9yQSg2OF5QvY+KDwI/q1B6hPdYPIY7Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5tcyDP3k2rbAcSxN1Ek79ZxOiOFOzJMeU/1ExcA7Fwc=;
 b=GCWHI+PpVDiLEJzN32FM745/e7kLLA0kQ6f0mfFDoBx1BfpVlv8ZJbZmMlT55EQGO3ei5tDUfSH0PDKZmFG16aGk0ECTinNkpQzczW35CAGx2LvIUQmUSuMP0Svf+1JfPzgk0ivK76bb/56jp7SqoC4clLT4akrPBAu2uAZjTzrD6UQeqXkkZIQox3/xLRjHj0GYOTmw5kghZZPOBUfyO+0ZPNcveDwRIVQgYX+wAU/gq4oYUDJ0C4uT9izBO22URA+4vm3DhFmn5C9HnmfZZRI3cz+y8ejtvqvgJ+J+jPU6p+ndWnvXS2SYhZGpm0XIDtUHGAATayWJZ08wjARXiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5tcyDP3k2rbAcSxN1Ek79ZxOiOFOzJMeU/1ExcA7Fwc=;
 b=5LGRfkD/mTM/taNnybA90MkOX8YhlMHO1OyCFg3qS/k4wLVbwOLC5wUNqrrJQMTIo8B5vGR+V9kr9sseq6LZ6RjtR0mePfBO+PuqVsgPtwuR323GZa28H4x+as7BFJcSlZW5AcAU3Tt05pXSLHZoisTg96bKtCuXofo8w5wlqZc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by BN9PR12MB5052.namprd12.prod.outlook.com (2603:10b6:408:135::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.31; Tue, 2 May
 2023 23:03:58 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::ea32:baf8:cc85:9648]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::ea32:baf8:cc85:9648%7]) with mapi id 15.20.6340.031; Tue, 2 May 2023
 23:03:58 +0000
Message-ID: <4420d7e5-d05f-8c31-a0f2-587ebb7eaa20@amd.com>
Date:   Tue, 2 May 2023 18:03:55 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [ANNOUNCEMENT] COCONUT Secure VM Service Module for SEV-SNP
Content-Language: en-US
To:     =?UTF-8?B?SsO2cmcgUsO2ZGVs?= <jroedel@suse.de>,
        amd-sev-snp@lists.suse.com, linux-coco@lists.linux.dev,
        kvm@vger.kernel.org
References: <ZBl4592947wC7WKI@suse.de>
Cc:     Carlos Bilbao <carlos.bilbao@amd.com>,
        Klaus Kiwi <kkiwi@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <ZBl4592947wC7WKI@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR03CA0386.namprd03.prod.outlook.com
 (2603:10b6:610:119::29) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|BN9PR12MB5052:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a713f50-edbb-4026-7b44-08db4b6182a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8NOSU5knRgFq/b3pyswc6PttkkxAbrGDqZvkdMDMx1b+hRUcgIZkxoxFZaqxDQ0Ochm2GOvjX3PTa5xY7sv2/z9hVDNKQD5ODefh+GyrYm8wNH+ioPTFt9x/ajteHqW7X4caKfFAzlTa/qd6Ymwpl2FOE12H6/6IV3DLbB/HtlHdOK8zMszH4ripyyg0lDENp1BXsTiIZUSa0Mr4Tqmt/ZHcNErnXN7FPTc6d2OCKc7BRZkf34u+tqIirFQGSldZ86Me5ZvhsmPGzY2CIQIV3AmWMG6QUcVvDI9IxCU0TC38qOpZX8KtDlh/PWApEjKpZj3sQh3fh07jM5aGca6MqyZAA+jJy/0Y8yW/rtRsMLQVnXvQs2Sv50LqRX00adi6kaRVZSbUxN0uWmDoVOImLW0Od6czVCvBeskxHVwt8bfTsfnbG5Q978lGqZ0JifjKrp4pQd1asdW5LBgLO9uTEt993fdlFe6jkDd8I3RTkIwvbarxsw73V5MEXXFPuPOq416qWHnFZdqRIUqW3+cDaDnHafCnVMrhhts66dYOnfJlvlI9qNQbOhvC5XfKW/T6WfY1YIsBr9ofesHXO4x0z4yTVC+jO1Kk7AdP3vmx9okH9FDRTk91ZvW7W1SOYHgziYJA+nF24rSMdl7ET4GSbw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(136003)(366004)(396003)(376002)(451199021)(6506007)(186003)(26005)(53546011)(966005)(38100700002)(66574015)(2616005)(83380400001)(5660300002)(8676002)(8936002)(2906002)(36756003)(31696002)(86362001)(54906003)(478600001)(6486002)(6512007)(316002)(41300700001)(6666004)(4326008)(66476007)(66946007)(66556008)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NEZoRE5OMWthUFBqeGtac2lWcktqRG1uVnE0SldJTTB0K1lXWXYvcmE5WlR4?=
 =?utf-8?B?TEZMZjYwVU44bTdVWEMxZ1lIOGtVeTh6OG5OM2xXTUo0aExUQ1BwbTJrZXdD?=
 =?utf-8?B?eE9pVW1NZGRJWUg1RCtHUGpRZlNKcVZ3ZER6OGxXNm1UT1RDQzJaZlgyY0xR?=
 =?utf-8?B?QjNTM0d5bFBkUnI2a3FOT3hKNnZjWHJZckxpcHMzVlI2djByY2QyeUpuYVBX?=
 =?utf-8?B?WG9TUUhOUjFsQ3JrZkJqWW5kV3VCamZxdDdwV2puSm1JSnd3ZnEvYStVUUE3?=
 =?utf-8?B?VUJwMGlKaEhySVp2L2Z5TTJkVEJvZVNyNkI0alpCUFMzTG8wekFpdGRjTW5p?=
 =?utf-8?B?NThGS1FwZm53eUJ4Y0RnbTNQNEVnNUVueXZUeWlMZW5TWlVWUWYvdFd1dmdz?=
 =?utf-8?B?eU9zMTVJMmVRV2pEMTgxMlBvNHRIR0pvV3k2VFRZRTBERkpYc2hRV3ZCamI3?=
 =?utf-8?B?dEZLZWFtUkxFNVBEY3BsYVNqVDZxUS9TVUIrRGM3YzlVZzg1eXB6QTVSUDF5?=
 =?utf-8?B?dC92WW1scUZOOUpoMHM1aCtTNmVrYk94OWtvUzQ3MXd1L2V1NFc3MXUwYUow?=
 =?utf-8?B?R2FlWHFTcUNESDJFdzBBckdndDFoeERXelhYSVFOYlZ0YlNnVnY0VnB1SjJH?=
 =?utf-8?B?MGR5KzZ3d3Z6MEtGdWNZYkVQQjhETlEvR1hlRDVEVHcyK1BwK2ZDek1EWUEr?=
 =?utf-8?B?RU4rUHVFQ3Y3dG1xRGorT2NDWFI2SHpUdVpDOUI5RENBQnBCTkpvYis1RGFq?=
 =?utf-8?B?Ynd6b2hJTlExR1dzUUxxYW92TDZZOTlDVG83SnRaNll3UGtYOExQTU5aTEZF?=
 =?utf-8?B?MjUxdTF1NWVLbFl4Rk84YlFyS3RIQ1Y2VzdMRFBuS095M3BMUWIyOGN3cTFN?=
 =?utf-8?B?ZlIxNkNuRDlKT2FjTXNzM2JabzVYODZnY3NLYW5MblF5ZHlQS3BxWDN3bmlt?=
 =?utf-8?B?YWhmTUNMbytKdWlqYmtoSG9Ha0s4YkdMcHJWWDRlaHU0SGJQWU1GRFB2V01p?=
 =?utf-8?B?c0oxWnpBN21PNktKVms5MkNOdlhkam9SVUJhM29KcjNOdzZ2MUJuR3U0QU01?=
 =?utf-8?B?TGIwWHVrdVYyQmczZXl0dzlaTmg3K3UrRmlSSWo4clpFajU0YlViajh1aEpn?=
 =?utf-8?B?KzZKUytSaHdQRVlvT3haUmdGZDhOM2kybVZWcGtFdWtxZDA2dUhuODhsOW5n?=
 =?utf-8?B?Z0t3VHNGeG1vSTZrejhMUVZUbGEzRHZ3TWZjVkk1OGlOTkFWZHEvUnp4Tnhk?=
 =?utf-8?B?RHFIMWN3cjdJNU43cjdJYmJrcTRvQXAyb2VuaGNZaXA2Qmp1SU85UnEyaFpT?=
 =?utf-8?B?eXBwTzBwQzBvTzZ1cDVnUTFTUjMzWDl5Q2V4Q0RpT0xKejdyTWtwMUtTcnE4?=
 =?utf-8?B?TVp2dktjYTdtTEVBUzV6UzFuVTdJM1lOaVFWREJWTnhMM0ZrMWE3WEY4WjNr?=
 =?utf-8?B?ZmJOdlhPOEFtQWtvcUh3RVVxLzlvMVgrV0ZGSTY3ZkpUN0RwYjJGUmNjaUFQ?=
 =?utf-8?B?MzlLWXgrWEZJREhKeC9GWXV6YzdEOGJ0dzY3a1NaZit5cnY5RVAxVHkvMEt3?=
 =?utf-8?B?UVVVVy8rUXdqdS9mS3FRTTdpOTJRby9PK1FEYWxWbS9oUjV2alBBZEJHT0Ny?=
 =?utf-8?B?eW9vYjJ1UXkxa3hQcEJMTUF0RXJPeXRON3AybXN5SlVFVmRrdUFpSUJucC9z?=
 =?utf-8?B?dnZoOXVpOTRncHNIQURhemYxRmVpV3VNTDF2VTc5VUhlQXl3T2hqRlBPSjdR?=
 =?utf-8?B?L2QxUHcyTHUwVVBPMGx4bFdGL0k1b1NaY1BXYjRydzUyZ0VWRXE3S29RczAx?=
 =?utf-8?B?ME0zQ25qeUlocWorMitRRVNzY1ZYNW90dG14cDNwZ2xzdjdvbFNrRFRMbW9M?=
 =?utf-8?B?VklsZ3BpQlhwRTVmbS8rUVZqSEU2L3N2VmhUNEZvWmVZZU5RbXdxWXpKdnls?=
 =?utf-8?B?bmVUVXV1T2M2aEFRdTlneW9FVElkNm5QLzE4UFgrU3NqN1JXa2ZaR1lPeVFu?=
 =?utf-8?B?eHJNZU4xV1g5c2RLQXBiNXFlY3V5NER0VW1DZTNoeWxveWlrZGZIVEJMWjho?=
 =?utf-8?B?RlVnYnRjYTU0dm81Mzl6MHVleC95U1RhTXJEcVZ5Q0dmVzlmQWpuSks5Mm4x?=
 =?utf-8?Q?JKwaYtn5G7/av9xtbsn0l6L4r?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a713f50-edbb-4026-7b44-08db4b6182a0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2023 23:03:58.0813
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hngWKLwkPnTZftm4GpXTqebgtndpXLdBcTw5t7HM5AztBtr8MIFAESss8BiJ/mngZ+WaHyW3B1VHpehy6hwNiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5052
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/21/23 04:29, Jörg Rödel wrote:
> Hi,
> 
> We are happy to announce that last week our secure VM service module
> (SVSM) went public on GitHub for everyone to try it out and participate
> in its further development. It is dual-licensed under the MIT and
> APACHE-2.0 licenses.
> 
> The project is written in Rust and can be cloned from:
> 
> 	https://github.com/coconut-svsm/svsm
> 
> There are also repositories in the github project with the Linux host and
> guest, EDK2 and QEMU changes needed to run the SVSM and boot up a full
> Linux guest.
> 
> The SVSM repository contains an installation guide in the INSTALL.md
> file and contributor hints in CONTRIBUTING.md.
> 
> A blog entry with more details is here:
> 
> 	https://www.suse.com/c/suse-open-sources-secure-vm-service-module-for-confidential-computing/
> 
> We also thank AMD for implementing and providing the necessary changes
> to Linux and EDK2 to make an SVSM possible.
> 
> Have a lot of fun!
> 

I finally found the time to go through coconut-svsm and compare/contrast
it to linux-svsm. Overall, they are very similar once loaded and running.
I also took the time to preview this with a couple of our most prominent
linux-svsm users before I sent it out.

While both SVSM implementations use the Qemu Firmware Configuration
(fw_cfg) interface, the coconut-svsm relies on it a bit more than
linux-svsm. In either case, other interfaces may need to be supported in
order for an SVSM to work with a VMM other than Qemu.

Some of the main differences are (just an accounting, I'm not saying
that one method is any better than the other):

- Both SVSMs end up located in a memory slot outside of memory that is
   reported to the guest. Coconut-svsm gets the location and size from
   fwcfg, which is customizable via the Qemu command line. Linux-svsm gets
   the location and size from the build process and validates that location
   and size.

   - Coconut-svsm starts in stages. Stage1 starts in 32-bit protected mode
     just below the OVMF firmware (just below 4GB), copies stage2 and the
     SVSM to 64KB where further initialization is performed and ultimately
     with the SVSM being copied to its final location where execution
     continues.

     The current stage1 location could limit the size of the SVSM based on
     the MMIO layout of the guest.

   - Linux-svsm is loaded in its final location and starts in 64-bit long
     mode. This requires extra setup in Qemu for the VMSA, but no
     relocation is needed once it is loaded.

- Coconut-svsm has developed its own IDT and pagetable support instead of
   using the x86_64 crate as linux-svsm does:

   - IDT:
     The main reason for the IDT support was to be able to customize the
     entry code, especially when CPL3 support is added. However, that can
     be done with the x86_64 crate by not using the "abi_x86_interrupt"
     feature.

   - Pagetables:
     Page table support can be tricky with the x86_64 crate. But in general
     I believe it could still be used. Coconut-svsm uses a dynamic offset-
     based approach for pagetables based on the final physical address
     location. This offset could be utilized in the x86_64 crate
     implementation. When CPL3 support comes around, that would require
     further investigation.

   - The advantage of using the x86_64 crate is getting added testing and
     fixes for issues that might not be immediately evident in a from
     scratch implementation. While not a issue, investigation could be done
     later to see if it is possible to move to those implementations (if
     desired).

- Coconut-svsm uses the ACPI MADT table to detect and boot APs. This works
   well with Qemu or any VMM that builds the MADT table. The linux-svsm
   makes use of the GHCB APIC ID list NAE event.

- Coconut-svsm does not measure the VMPL1 BSP VMSA directly. It uses set
   values that are measured as part of SVSM itself. This does prevent
   coconut-svsm from being able to launch VMPL1 using a different, measured
   BSP initial state. Linux-svsm, after performing some validation, does
   use a separately measured VMPL1 firmware BSP VMSA.

- Coconut-svsm copies the original Secrets Page and the "frees" the memory
   for it. I couldn't tell if the memory is zeroed out or not, but
   something that should be looked at to ensure the VMPCK0 key is not
   leaked.


Some questions for coconut-svsm:
   - Are there any concerns with using existing code/projects as submodules
     within coconut-svsm (e.g. OpenSSL or a software TPM implementation)?
     One of our design goals for linux-svsm was desirability to easily
     allow downstream users or products to, e.g., use their own crypto
     (e.g. company preferred)

   - Are you open to having maintainers outside of SUSE? There is some
     linux-svsm community concern about project governance and project
     priorities and release schedules. This wouldn't have to be AMD even,
     but we'd volunteer to help here if desired, but we'd like to foster a
     true community model for governance regardless. We'd love to hear
     thoughts on this from coconut-svsm folks.

   - On the subject of priorities, the number one priority for the
     linux-svsm project has been to quickly achieve production quality vTPM
     support. The support for this is being actively worked on by
     linux-svsm contributors and we'd want to find fastest path towards
     getting that redirected into coconut-svsm (possibly starting with CPL0
     implementation until CPL3 support is available) and the project
     hardened for a release.  I imagine there will be some competing
     priorities from coconut-svsm project currently, so wanted to get this
     out on the table from the beginning.


Since we don't want to split resources or have competing projects, we are
leaning towards moving our development resources over to the coconut-svsm
project. I think we do need to sort out the governance question
(maintainers, prioritization, release/schedule model, ...), but I don't
see hard technical blockers. For others in the linux-svsm developer
community, please ask questions or voice any concerns you may have so that
we can see if they can be addressed.

Thanks,
Tom
