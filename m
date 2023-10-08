Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE06A7C00D5
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 17:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233403AbjJJPyH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 11:54:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233493AbjJJPyG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 11:54:06 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2078.outbound.protection.outlook.com [40.107.244.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F734C4;
        Tue, 10 Oct 2023 08:54:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LejsAsj6o9ZHDo8jfCj6qsNsEs7MFhgXxjzuIoecEystm/Dg/949QOFa88x4ktyytuoYRq9fyaYIDVlEs1kS43tNUUVotT1GAuLGlWsjFDAfksFiaEoDSFRTHUD6EOO/BhPlv5Mbs4qzCAHcYa3g2jod0BKg4KwOymE4C5KWHZ/1//wqPlS1cNIJ9hrABI2LlKSTliaJUin/fxMa98MRyYi7Jjsj98rgpnvVXw8wPBFWKhAVn//h4VFrRA3JYNPugMcioNGig/DqICmteb61HhWjMMDxjM8FSO8viMq5y2RKaE+TsO0nt125CwFIKnkJ5CesMT6J2xZaGIL/CA6gwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5TTXujzc9zemR/3x1uNnar+O/J4HlYfdAybj+vQAwrE=;
 b=AOjGg60n9rb1+0dsI5VyX9Sbv92E0fdAe31GRjvjkEjJU7sBUwd4ovJ85XR1wIzz0PcogN+UiM1HdMf3YiQqFcIBSxv9FtgpMvl5Tz9Mo5P1wsO3Z9Y2lij4rmPp9VeKkiW16Bes1/WPp9sc7r0E19eAW13N9jwylXrfgkH227Nb1e1XCPKZPUCMe66cXJ3UjYyyG3M89bChNGIW3Pm4o4ALmBbd0OBRUy4SrbgARFsoZNL9JLG6oikjkbkIMxPPOdlnPTpoEaCUWgIHcqavO+aTAZdWsGWn5B/nICQ190jTzAkO4fnMlcV18R0HvQGmMbgwNKHpSseJeRlYs1WYmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=memverge.com; dmarc=pass action=none header.from=memverge.com;
 dkim=pass header.d=memverge.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=memverge.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5TTXujzc9zemR/3x1uNnar+O/J4HlYfdAybj+vQAwrE=;
 b=VmSt4+W+lsB90Bl4KfzRrCVFhM1taTzeCa0RJxInqFatvtqdi510ECYe99gANPJmfnTBED4cY8obAHusdNur+66fs0FO6FcSJEiszsatM9lQjI8JM6dW+OUI763wM85+9KB8YcKw/KwdeZlbrHa+hbthqW01joTeKD8H5cUJyrM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=memverge.com;
Received: from SJ0PR17MB5512.namprd17.prod.outlook.com (2603:10b6:a03:394::19)
 by PH0PR17MB4504.namprd17.prod.outlook.com (2603:10b6:510:c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.36; Tue, 10 Oct
 2023 15:54:01 +0000
Received: from SJ0PR17MB5512.namprd17.prod.outlook.com
 ([fe80::bdfd:7c88:7f47:2ecd]) by SJ0PR17MB5512.namprd17.prod.outlook.com
 ([fe80::bdfd:7c88:7f47:2ecd%6]) with mapi id 15.20.6863.032; Tue, 10 Oct 2023
 15:54:00 +0000
Date:   Sun, 8 Oct 2023 09:29:09 -0400
From:   Gregory Price <gregory.price@memverge.com>
To:     Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc:     Davidlohr Bueso <dave@stgolabs.net>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Alison Schofield <alison.schofield@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-cxl@vger.kernel.org
Subject: Re: Accessing emulated CXL memory is unstable
Message-ID: <ZSKupRw+mRrASUaY@memverge.com>
References: <CAB=+i9S4NSJ7iNvqguWKvFvo=cMQC21KeNETsqmJoEpj+iDmig@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB=+i9S4NSJ7iNvqguWKvFvo=cMQC21KeNETsqmJoEpj+iDmig@mail.gmail.com>
X-ClientProxiedBy: BYAPR07CA0061.namprd07.prod.outlook.com
 (2603:10b6:a03:60::38) To SJ0PR17MB5512.namprd17.prod.outlook.com
 (2603:10b6:a03:394::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR17MB5512:EE_|PH0PR17MB4504:EE_
X-MS-Office365-Filtering-Correlation-Id: 0719a92e-7e08-485d-88c5-08dbc9a91ed1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +X8IQYixt8+9wwe6GTn3NfiuUQyr/fcvBljf+7DoVwW1ed86jbiaIyik9s/e5ygaioIpdWw/UecxEtrqFT3psffb2Cc75RGYT3nKiMmDg0YRu945AHmvEX0ut3/FPFyyqUR5H511RddN5AcTO+4q69duDQQfY8YpCMbUFpMS6zDUvjKnItNX4zMA3cnUwsprhNFKMy2xhg4deKxtws5Z4ep5BdsbtP+gICCm85nGqqoJHkfiNow2lSS9uz3nUnfY9vatJVfBVQbnOeQ9mdgJ5oyCZ8wujqESkbjUrQfN8Fri49pOhRd1em2OX6b1J+hBUteNXIWB7IXTbzPcY/pkXbg5FIBWFqy7elcB5bHoU2cNBrbtpI6LgRMfMxRtC2NrefPEzANglmVgHGb4m8lPWDpcV8G+30Q/HDoK9+b1wzS2l99TWfbMYd+rc0hvqDAm2RepwNkPMSCqZyGZcvBpgmCPvfq6zwHBJx11KMO4iPLKg58e85BhzE7XWvYN8iQhCO9B6WoCIiZxwZWUMlXNVkrRBQfbEUFXPyjHYwgheY6+kVmKf0I6tYeq+4G8mVCmW9nrB4ogBeCS8X7NzN5PJcWyyGFbdtcbLJW70/jqM+c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR17MB5512.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(376002)(366004)(39850400004)(136003)(230922051799003)(64100799003)(451199024)(186009)(1800799009)(5660300002)(26005)(2616005)(8676002)(8936002)(6512007)(2906002)(478600001)(7416002)(6506007)(44832011)(4326008)(54906003)(66946007)(66556008)(66476007)(41300700001)(6486002)(316002)(6916009)(38100700002)(86362001)(36756003)(83380400001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OBLfIZaajJ73KNkbNj/yVhIbRMsem4wKo2ioxF7itgGv5hpzTxIl5CpUqeik?=
 =?us-ascii?Q?UFJAPGQiw4xOdTRGCJvozM3Z3ZMW1rvb7qSMmr0OorzxhFkUeE5bHnSzlerM?=
 =?us-ascii?Q?w9pESxBVTGrJjid/oaK5M7vQk/Ri/Tdnx8QOqQDv6J2lHGNnDVsvdU0FsdTT?=
 =?us-ascii?Q?rNwAMKv6+6ft+98aBRe23mnDhC/v60ghxm1GJ229cWAVu/Xg25tVaqIy2BEp?=
 =?us-ascii?Q?UWqqi9wHsrhb8S9rv4c3g5pwxegLubbvdCm4cFuZ3Ria6rKBPHtL8yMcphu9?=
 =?us-ascii?Q?hEhcI9uDR8TDfvpQGvwTcSf61QI+kOsoacNNmYb0EPs0IYCDdIHJwivtLKbc?=
 =?us-ascii?Q?a9aT89bFgeMzbUbq7OWymonbZnAGM+ZowK67yP1oYBiTRsJ/Ed64It3cFJNZ?=
 =?us-ascii?Q?wFV6g8JE3xhZgoG1pKHs6sXwvsLm97azzgrt+Vckoo3kY8uCmCAKspfNYzOg?=
 =?us-ascii?Q?Kc4GXC8Vzc+LfNFxShDbYBj8aJO7I2softtPoUKno93QS5y5dz19U9N+klJQ?=
 =?us-ascii?Q?UhvMaeoN01/IVtRylf4Fn08Ti8X/6FQL/w3NROXkWuEGnqQprr4D+EFNT2Mj?=
 =?us-ascii?Q?OlIixV7hOqnJbSa5eCTtz1pZgBua36K2nuSTQ/pBlcAeXd1ymjTq+OSZAswG?=
 =?us-ascii?Q?uBKxx1+fiPV5dQjF8RKFIPSUgs1sraqk2p4nSjJ4UZduVUwJWfOqHnN1j2y9?=
 =?us-ascii?Q?OwjrELE8robQXmoY9qiFSepkQ/lTBbnG8Tx+bWokcS8lY3COuBK9VPJdbQjs?=
 =?us-ascii?Q?4A86bSAJzeSKnvAvkl2CTTMjXe0S6qXzn2EvTjflcjfM76IYgVDd8eGtocIW?=
 =?us-ascii?Q?C93kSjRqpglpHxCAtoifJib2XowAUzRvy5CXX13E/rvi+viLkr+5PdIKPefv?=
 =?us-ascii?Q?bKHuAlK5jjT8OBvSZRe4xteP9/KIYc5MH1sq6SjQyXTtUbA8ZYLN/VdajSd8?=
 =?us-ascii?Q?JXEbHEDG8f9pMQlWe9Fk8cnJKlXa05jqI1UuuzNESASPcs9GloM6pzopDZpd?=
 =?us-ascii?Q?qe2ht/ja3AGqs3tUdA7lBkr7jTguECNEEp4mNJtVT8N+nWFlJtnKExijakz7?=
 =?us-ascii?Q?0rccXnhdDk8xSKR3XqGEbWPq8HGEdem0rZfNTrWraNyT/dAkogciOQgTEkXX?=
 =?us-ascii?Q?fj+iZHC0xfKFuY+bx9obvVBjcBB6G5zxvIesPGL+X66D/7MDwQ31gfwZfO5B?=
 =?us-ascii?Q?TYNE85sMiSrIxV1GdGxUMtie7l9J5fPTXsn5ZsV3tAiSM8s6tlMROMQlIpdS?=
 =?us-ascii?Q?eIpRJo3bGhMLW0jAR9avSm1ETZ+mCUsf9Qm2WIzshiEyDkZiIVbLrmrtjBtB?=
 =?us-ascii?Q?zz0Q11O88V7H0vi4jn9xyD75ObiP5uxnTFhT9OebIyjKKpx621uVZeb/5Eeq?=
 =?us-ascii?Q?Qu8uRtB/EN4Nk4ls1+iQ8caoRceGvHiAIjq19DgjJlwbfU7Qg2vH8Tcu2oWg?=
 =?us-ascii?Q?6fNn8D/5A7j+qFuigtHofF1U0c3nwAW4DhJDDkGktEwrxOj6aERfYUZMB/3r?=
 =?us-ascii?Q?r7mjqoHG6+IevLEvmSpqOXp6J6LfA53nN1D1eG0VSQDI1FABIrH2UjDhP1wW?=
 =?us-ascii?Q?PwfUwyaBarNTMLHaIaypAWxY25gEliYTvMH7K5rb44J0ZBtnQi4fcItdYdCB?=
 =?us-ascii?Q?8A=3D=3D?=
X-OriginatorOrg: memverge.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0719a92e-7e08-485d-88c5-08dbc9a91ed1
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR17MB5512.namprd17.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2023 15:54:00.8165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5c90cb59-37e7-4c81-9c07-00473d5fb682
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o8yyRF0Uq5oESQVWrwNAu+lorbRHWC7VDsKzxgGsoGkwfEmfX5Xdv/kVaUQ2OVpQrHlBj13fZC9yiTRYNzLi3AxNn23zFXGD4xeYusan+lQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR17MB4504
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 10, 2023 at 10:35:03AM +0900, Hyeonggon Yoo wrote:
> Hello folks,
> 
> I experienced strange application crashes/internal KVM errors
> while playing with emulated type 3 CXL memory. I would like to know
> if this is a real issue or I missed something during setup.
> 
> TL;DR: applications crash when accessing emulated CXL memory,
> and stressing VM subsystem causes KVM internal error
> (stressing via stress-ng --bigheap)
>
...
> 
> Hmm... it crashed, and it's 'invalid opcode'.
> Is this because the fetched instruction is different from what's
> written to memory during exec()?
> 

This is a known issue, and the working theory is 2 issues:

1) CXL devices are implemented on top of an MMIO-style dispatch system
   and as a result memory from CXL is non-cacheable.  We think there
   may be an issue with this in KVM but it hasn't been investigated
   fully.

2) When we originally got CXL memory support, we discovered an edge case
   where code pages hosted on CXL memory would cause a crash whenever an
   instruction spanned across a page barrier.  A similar issue could
   affect KVM.

We haven't done much research into the problem beyond this.  For now, we
all just turn KVM off while we continue development.

~Gregory
