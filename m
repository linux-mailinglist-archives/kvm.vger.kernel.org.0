Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D30A731C5F
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 17:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344982AbjFOPXO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 11:23:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230500AbjFOPXL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 11:23:11 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2082.outbound.protection.outlook.com [40.107.95.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FAB92126;
        Thu, 15 Jun 2023 08:23:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fgg2gzXF+V6c0frthnRBkP6g+sQUXsGnca958atdfOfUZZv/jhEwCziQJGQnn+3JGwomp0PpnCbNpRCdb0WYhMOLqhwqwKQQgEEG9C8rSch4t0aM9AZCZLWBoVBF7VTrCMcEPyoxDPTJLzqlaNIEm1DEIOHpH59wRbQU4qSQoktJazqRPSFwnvs9JwqBb55SVqqoW3dMdRLz2Ls1tsRfeTdERFZd31W20uhnuSPcg5dR6yIJdCFSpjNBpivyR+VhaXYoiqRdz8acw/K3IOHCatyOaKe7n5lCcTNwcwV9nwWrhjeFEMtCacT7FSQzbWXMqxoMUacsGPd+Afne2sJ2Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eSePoqosDWH+M2pNeUXyscor3f51vudBQGvvaxMiwBw=;
 b=gAJ0GejWrew1QfRKCAZdUuUarXFNpv/nZucafmeofc7J4qZReplnCxfmqHcsrqCNVKcl9Zi1Top/JUoseUJUm2eKOCWB9YB7/LbX70GmkzFDZsrRbUXslcDk3+5CDRGIO8Z5UoYhNxM8PxBmDAoGlWicMwuCrtRfcO4/Q3Hj+VBl869FNYg6S+ZdCZIB85nTtnvkhpuEZrjhhY6Q5prt6tzrGmhuQXeDxf66PYYDBgLo8Muz+mSQBjZtww2ZiLQqoc1lK8cjxFi0KjKl8G6ubczSIYgvEsyoER/jDIlwyPU6l+YLBkrCPLioE10Io+OEPe9ItGawq9YDsGp17VE3lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eSePoqosDWH+M2pNeUXyscor3f51vudBQGvvaxMiwBw=;
 b=llW/7px9Odp78vuBeOf7hGIl4ERhwCGjF8VppIVdbTvx07Sm0uTv8ME1a3AiuEAqKSvF6aIReiAhwCiqA2GnNZzqOKz/NmI0mXpQcl1i+RpxdDZGys53NrVDarJEJZJ2wUZcOS0pIPNQZHlaMDZEuPDFkO0Rq+ZLVgs2caQ4nAQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20)
 by BN9PR12MB5338.namprd12.prod.outlook.com (2603:10b6:408:103::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25; Thu, 15 Jun
 2023 15:23:07 +0000
Received: from BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::a2ee:7100:47ad:1476]) by BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::a2ee:7100:47ad:1476%4]) with mapi id 15.20.6500.025; Thu, 15 Jun 2023
 15:23:05 +0000
Date:   Thu, 15 Jun 2023 10:23:01 -0500
From:   John Allen <john.allen@amd.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, weijiang.yang@intel.com,
        rick.p.edgecombe@intel.com, seanjc@google.com, x86@kernel.org,
        thomas.lendacky@amd.com
Subject: Re: [RFC PATCH v2] x86/sev-es: Include XSS value in GHCB CPUID
 request
Message-ID: <ZIss1TJ3ra+dZKOg@johallen-workstation.lan>
References: <20230524155619.415961-1-john.allen@amd.com>
 <20230615115255.GBZIr7l2XNKau16ayl@fat_crate.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230615115255.GBZIr7l2XNKau16ayl@fat_crate.local>
X-ClientProxiedBy: MW4PR04CA0035.namprd04.prod.outlook.com
 (2603:10b6:303:6a::10) To BL1PR12MB5995.namprd12.prod.outlook.com
 (2603:10b6:208:39b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5995:EE_|BN9PR12MB5338:EE_
X-MS-Office365-Filtering-Correlation-Id: a0808cb6-99ca-4c1c-488b-08db6db46aca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U6DDW7U18Rt13r5nqYJlV16a5ASF3MJc2x9W0HB9rPrzjiu+ekEkivwII2aJN7J3kC04Jo/Dz2jw2Qy0zACJvDxv5/oBcT8BQZ7wXCVA0TYDViTqT8gi3GBb2+YcKwnGolSlRsroaVWDk6ShTV4spy3UNgObtRpv1WuH1IAaGVlqgikJjjnIWLz/5lqvypOETcp5hdvOYm2t/gm1BAdskR74VbqGRYhxgQRdoG3ZHpZ0afy3irOudp48RODTrLczUC6x84ooZ3DYPo5pSjFERImEWqYh8GT0kk6J6+ZD5JbfG80NJ6s2jTP4eSXmTVTGsw/wRNaUIQBK5hK+GgG15kLsEje3ibk7ZIhCvVjusL/xPQDFSI0/AxVPLYILNW0QnsYTDmy3lWjX+otsSNrx9tQX0LUIhtrc1S+48n22lBVeDw8gy3DJN733upirsWX+k6twzu26103Bah1HD4hvCOcKaQ4A9UhPvTyYZwR4PV5BNAXOJ+d0fVdWyH7ZdMNeAXDNgJzPxdvQP4h3ptsbSaaJaPrO3ywtkMJ3/pWWc1XEkI+e93sFoIHkqp0t5FJ1ZPgTuTnE5w1EGPSGk8uLVsSzax7VenmcLQinf/53OR4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(346002)(366004)(396003)(39860400002)(451199021)(5660300002)(966005)(38100700002)(6506007)(186003)(2906002)(26005)(6512007)(44832011)(9686003)(478600001)(66556008)(6916009)(66946007)(66476007)(316002)(6666004)(8936002)(6486002)(8676002)(41300700001)(86362001)(36756003)(4326008)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FB2vInsy56TdPa+i1g5WiTbvfcETTk6hMZ3gGOphpbDwipaqBRSv/3rgELg2?=
 =?us-ascii?Q?BYs8KhFf/PpQZAwe5zrNVcu3pLhxKgbg6g6HtGD32tq/j5/0a5xK+SeEpM1e?=
 =?us-ascii?Q?FMFagXthjDmi11PPy7JA7RIQrnSmPh8Bcn6tlbwK8ttuyif0/uHM0iJ9Ss4K?=
 =?us-ascii?Q?tp4FUNQTMw0lCQT92T6SFcyOqErpmW/IVeusmvIVwWM56v2Aljn75Tv3UYVg?=
 =?us-ascii?Q?R9+PebCH0O7Q6voKKk21fPWRaG/MecmWBqw9OdLxyAvBIYI7kIsWn/XtbmGO?=
 =?us-ascii?Q?Wer4TFFtQzLwUrd6wdhdbav7W8NAIlKcXyzyjJrm9APNyEO2X8oYHZFleCP+?=
 =?us-ascii?Q?Q7FYYEnRP8JwMkld8a5iOOo0o1K0IVnLJ/gh/aJH1Ht0PMgA+jQfo1yL8BWs?=
 =?us-ascii?Q?xGSAP+BZGYYdtrYZQNyyDmmwp9eIwgAUwrkkG5ipebTpCv7a6FVt9VVAG8g3?=
 =?us-ascii?Q?054Rfi8GqNkUPg8vSPSJqggzOnzM2jGnIafxreZfvf3nmOcp6b9qtKI7Q8WW?=
 =?us-ascii?Q?TkwQ8TPUt416/I+rCUIFU+ByuibXKXYz/f9GpAIMUgd7Qlu+N0pkDPEhTc+d?=
 =?us-ascii?Q?9rsAXkUky1tfBsL05Ur7Wgj+nHVOQVQYFWJh2J/1c0tDop6d5CclUB6UNvb2?=
 =?us-ascii?Q?OR9WyXCvlvGFKZnM1Bt2Amh9gYy1pz5VQiYOYg9DnwQsn7m37QKVYDQLJoZ4?=
 =?us-ascii?Q?DmZBh6c0rnm7ttkx0v+feDlR20tPhUy7K/VWUU6EMrySKMBpssBdcDa8dAfl?=
 =?us-ascii?Q?2/XzpwuUYvKsDvZBCYpwqO9MXYjpCQ5PSbLtAjgBByZff9HhcNmb3/2WqCjV?=
 =?us-ascii?Q?zKLNTeGtN/0u6/gOacj4N6nwKPZMuwxDjO5GrULH3DnRTV/YzoMzLDEHgz8G?=
 =?us-ascii?Q?o0RNUzeCdzx1qVfZEM+HvlQyuR+kPQJNUhvrEQ1rxwyGx87UqFIUC18ksLvy?=
 =?us-ascii?Q?wjrk+eOwcY9Cru6smeHlaJTAfMcdtgZg9ygFc1y0x+iCsYwKQyvspZlP2Yb0?=
 =?us-ascii?Q?1zPVjOSp+ue473IwQDihWHfq/SO3/e77JniR96DCETkqVhOvfdaB8A8neElp?=
 =?us-ascii?Q?Ct0cqtCikpTNTZgHBQ10nffSs9zvWuhQ4mzQxv8wNVjQKv1Hr23oqU17LLvb?=
 =?us-ascii?Q?NtwxdX4YhLtuQRshNIgr7i2/qTemjpo3gEIC2KmlahOVAwxSsj2/qJGet3f4?=
 =?us-ascii?Q?MEKzjU8fJq3HUC0+Y1JPFQbNvQA32j2r0cIB819LsANFePqx9yQEplgY8IOs?=
 =?us-ascii?Q?V7/T5snb0+T9bioDwFw0++kwM3FlcWFRRN7nZiyut+G8C56wShktzPn23Kto?=
 =?us-ascii?Q?Z0NoM1pW3L/iRnIXfOlbv82bkjFcgtE0NIwcwLFzptvZUpwAARhNCYuR34mo?=
 =?us-ascii?Q?UVqG/lmj8NpqSTl02D1Io3rgglcjk8Kqa5nf/dewrtzffXyhb/Fmt1IiliW1?=
 =?us-ascii?Q?cH94m/65zBqulkW2rDGDTcZatBRCmOBG/OZLZ+cJmVjkrvrXMRjFUmtdAdo2?=
 =?us-ascii?Q?soSOS+ncUgdZeXcsIP0Xb1KXh24JPgt2lVYmUYftXqMeCBoGbRrr4oYl2KAt?=
 =?us-ascii?Q?e01PzRkdTwYW6ZI8wVjqQaHa6fiavRSk45m+zHc+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0808cb6-99ca-4c1c-488b-08db6db46aca
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5995.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 15:23:05.8120
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rEhBmf9BKXD9ET3BUyBEzIqF4FPl6WrgNRsipRm/E/qQvWlsDenhnpQjQIdvLT3R3zC25YSf+aO6hYvfTTGPGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5338
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 15, 2023 at 01:52:55PM +0200, Borislav Petkov wrote:
> On Wed, May 24, 2023 at 03:56:19PM +0000, John Allen wrote:
> > +	if (has_cpuflag(X86_FEATURE_SHSTK) && regs->ax == 0xd && regs->cx <= 1) {
> > +		unsigned long lo, hi;
> > +		u64 xss;
> > +
> > +		/*
> > +		 * Since vc_handle_cpuid may be used during early boot, the
> > +		 * rdmsr wrappers are incompatible and should not be used.
> > +		 * Invoke the instruction directly.
> > +		 */
> > +		asm volatile("rdmsr" : "=a" (lo), "=d" (hi)
> > +			     : "c" (MSR_IA32_XSS));
> > +		xss = (hi << 32) | lo;
> > +		ghcb_set_xss(ghcb, xss);
> 
> $ git grep ghcb_set_xss
> $
> 
> So this patch needs some tree which I'm not aware of.
> 
> Also, this passing through of host XSS to the guest looks like it is
> bypassing the vcpu->arch.ia32_xss copy which KVM seems to maintain. It
> looks to me like the handling needs to be synchronized with it or so.

Hi Boris,

Yeah, sorry, this is confusing. This patch is logically part of the SVM
shadow stack support series:
https://lore.kernel.org/all/20230524155339.415820-1-john.allen@amd.com/

Since this patch is for the guest kernel, it is meant for the tip tree
rather than the kvm tree so I sent it as a separate patch. However, as
you noted, this patch depends on patch 5/6 of that series to introduce
the ghcb_set_xss function. How would you advise that I handle this
entanglement in the next series?

Thanks,
John 
