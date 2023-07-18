Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 662B975818E
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 18:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbjGRQAf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 12:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbjGRQAe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 12:00:34 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2072.outbound.protection.outlook.com [40.107.220.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51157A9;
        Tue, 18 Jul 2023 09:00:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J/plUWTAQcJAW09dnuEzUX7NRn/KIWPV/YqXyRUnBSjHcdet3T19WjissbqB4Q7SWghSB97CCapuZ300BJeofNRUCGuBQ+riJBiHxpefLHHdJkPpP7jd+TxNO/muk8dS8gT2iGFJFNoXqobcz7tlU2IzFehXXPJYAi6IG1jO6TkqnwKU01VR0WcLIxwtLkfKjVhO8fO/D2vEygi+smlmGesJHK303lk45gF9ilvdqjHpKuNjqZPjelnaLdNb4idDFnzOAKJ1mh0x9dne1vMOJ5FGFQ6xY3lhJK2GVc0l4qjbHS953iav/ae3wnbP9LvEbEQNsIyxFefmCFljYvtigA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sTXW8Bz2HuqwbH+pn4C7e1cAkccyWcZB0nBW31yfJis=;
 b=TDvRlfrIIZf0IfZnZkioIxdkZXOSgj/Swrm8e2wmnnxTNwqspqLAlbsLwNO+Ht1Z/XjagB/6wn2k6MEyJoB9JE8dMfecyPpfKUK5rj+o0gAsxmmkYkLFvKry9M51dXnsBIJXhNaccimgr2G3ngWyVK3DHHsBsIQlQhvdxkxQ+ncuc+To8Lv8XpgCwkq1exp5eh2F6kK1kZEjqN1kaVx0xXOtpTzgpgw5WwQLTORv2xgqc5QBxwz16OojuxLRG8Gl8u4QrH+2LAbdbXbo78KUpx+8nVqZ5N/9pd8H+ARWSg2eHjIpc1mV5gTFbvcOCbxujHG/7wbquvYmvwGJPBWE0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sTXW8Bz2HuqwbH+pn4C7e1cAkccyWcZB0nBW31yfJis=;
 b=NQGiLFt6ZruW2fmpUo1LlvcPyu1IutRRGeAjA3pwyK26YbYdBodESJRgX9TnVLSMI2cyudoXUlsg63hrU9qot+tINfi9PLW5AUcQOYwFULynIYlMXr9z/DTjICpVQQnQm7efXjMlMQZCIOLz/rTMRAeDKYW5+W82X5ZAqsz/Pk22LTZZ+YcHBuJ9ozwhBiXbVVEoJ21WPApxbikOijObPXFWIiH3ueumEGp2ihKF8eMPqrykFYubOVgcXbBz9gqrBwmNFBOVUORzTeNoCBSA25jy0W0stt4p3zlBYPkCA02Rx0vqk7VOVBOs8219Oxm2rF4MsGIdbyoH9WYpEGao5Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW4PR12MB7213.namprd12.prod.outlook.com (2603:10b6:303:22a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.31; Tue, 18 Jul
 2023 16:00:31 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1%6]) with mapi id 15.20.6588.031; Tue, 18 Jul 2023
 16:00:31 +0000
Date:   Tue, 18 Jul 2023 13:00:29 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Sean Christopherson <seanjc@google.com>,
        Roxana Bradescu <roxabee@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm/vfio: ensure kvg instance stays around in
 kvm_vfio_group_add()
Message-ID: <ZLa3HcDnLyiQNXVf@nvidia.com>
References: <ZKyEL/4pFicxMQvg@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZKyEL/4pFicxMQvg@google.com>
X-ClientProxiedBy: CH2PR20CA0027.namprd20.prod.outlook.com
 (2603:10b6:610:58::37) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW4PR12MB7213:EE_
X-MS-Office365-Filtering-Correlation-Id: 2fca4c21-60f6-477b-b7c9-08db87a81cb4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +j7mQgJImZgCiEwg4Jiis4FMpDkTEQTi0t1wHJ2wAcvioGT+4oTS/T+EPTrkMgSUYS/SXkPQp+CKO3vRVrOWa5CmXlMmemZs82aDhHwPk855FnyYbYdtSD11J6oht6xQN6Yqd6TpW4zTtqanaVLWX6Xm7EYcCzlQU3SL1Q0pqnTDSjfAy9PSRLaju6xUN3u/Wbtilg4mSeW/i7IudLlO6Ipjg/H2VVJyD6kSWcl5OhhwCXqJ0ghZqmhYWg2ZuyN/AyICD2+FuPhRLzCEhUOQ/hBdgmWqvoet4cFAlE96uiYLNA83YGDfnOV+mZsIf49sE5nq9WxbiZY2tGvESFpLkwaW9IuL7V2qkDmcY0FSl6AgG45csGp/3JWuSSIUG91kfKDbgs5wMGOFyuJ7Z1fnEb/VYPPxooGiPUzJK8AnD3nIzIfNcIYecExVNDstrRsRcpShT3xTOoa2ygGlW4gkU7HIL6cvcgEqBn7pcJkfw7Oxe7ajC7B1UhrAS74mLL2rAmAt6n2LtREaFajljJRnzQPbWVGTllmHmhLGDannDw8RneryOY9HBs3YkYDOMWvX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(39860400002)(136003)(366004)(396003)(451199021)(478600001)(6486002)(66556008)(54906003)(83380400001)(86362001)(4744005)(2906002)(6506007)(36756003)(186003)(2616005)(316002)(6512007)(38100700002)(26005)(6916009)(66476007)(41300700001)(66946007)(4326008)(8676002)(8936002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eDqUcSdw7CTn5hMtnvTA9jXE3hYWVesiIMJv6srkejknieaA9ybe1bPwWdRq?=
 =?us-ascii?Q?JHSCGhcipS6taA7ux0PgFGvFl51jSnr1OC+n2kUhpgrlR1IR15UaPkeEHVax?=
 =?us-ascii?Q?njKBc7oMm+w2G1zi0oCiGFURBA47DeYL0gPAPTFpeFZjpdUunBmYrqAyW1sS?=
 =?us-ascii?Q?EXGXJMs2lTp64WowJnLDqBeUg5OzlkNLA9I7yySFSLlS0Dvdq+0d4K/jMe/l?=
 =?us-ascii?Q?7At7sEzcvmYbw7IjkGAYfHThupqyChjgzXxABVz7Rwmsn3v//XD0EkpYeg60?=
 =?us-ascii?Q?bZNyer0nDjbKsiIf8re44neZ9iphBsgYO9b/YFQjwIUtJeyJZaJs9giPsu0Y?=
 =?us-ascii?Q?yWVPnrLvFc84gsOl7SiVFzTgtwQ/dbIU2CvcoF+dbGw2hcBooSEQtZxYCVjl?=
 =?us-ascii?Q?+IkGtpg/Wg+gIVNDqOX0LdX+JUYZjc8Eu+5ibjBLYR9vtNRfv2AB5HDW9baJ?=
 =?us-ascii?Q?xqNTAA3eVomJR7142FmGB8y3fe6It6bOCI3fHri34nSLM4Auf66jskWcIxJF?=
 =?us-ascii?Q?7IWmUAqTOpbPCQ1nm/kb2Pcw2NJmq8oZBqjBS6CdqMhnmWSpDOx43h6sAt1t?=
 =?us-ascii?Q?mpR6pgk1TF3i1bag4uF+TXe+1htsPNdVliaQBTnW4Pa+IV1QE8DrDDkMwUv7?=
 =?us-ascii?Q?MsDt1JKJA+5QVI5I1gtQPZ4RNbttxERjIFk17Yj6u6g1YR2QzIbmHq5DTN4V?=
 =?us-ascii?Q?mGH7HAdedCeqSO6AkVR3y5RkNkAaBB7whieUjRWbdrvRPSJZ0xeBx+XJNlUZ?=
 =?us-ascii?Q?cTR8drtDnfaAjU7b1Th404Pryea7Sli8xEB2JWrJ6887PS50fJm8uBW75Vwd?=
 =?us-ascii?Q?Ie7UxCO6tqKppWIH45U6uZfiNermI1xwUWC6IeWclYrmvBSUzIi+ryxjM0G8?=
 =?us-ascii?Q?I4YIPFlkrMs8uQTuTxmDi3EZo589AWRQzBn6SDJ2sOlwRyZlmHo3Vkb2Urhb?=
 =?us-ascii?Q?LYGYp110Ff1aNTfqyTnKHaKnO8mlOPVq2BQsYMpMUbHsmTr6ovLc3qkGr2k3?=
 =?us-ascii?Q?vy5mqECkct+8UQEmcPziAkjm13TzfpEsNNXQJO1FHao8cuc+oQOeQyh5fnUO?=
 =?us-ascii?Q?ydPjhTSOGbzFBwffTSOth7vdd1E+YYKIhdw+Se1xkdo0pP1wEzLaJa/FoSdx?=
 =?us-ascii?Q?t6XOsBdPfGutqpzLR+Nq0qyBWH3XYH3CCIr1EYn4ZCjMMjwZDQYs5I5I0zAo?=
 =?us-ascii?Q?H7VB4QKW0ubteTSHhh6+04VxF+a0cyBJ47BR/QozuPpR84gdmJ1Hu4T+4nzK?=
 =?us-ascii?Q?esMQJnZ8M7b7CTvoBDpRzik1Xk8FI/0aoTWQjQ5aSPwQv0kO3gKayhMuIuPT?=
 =?us-ascii?Q?CnQ/TQQr7s6A6DkVeY6VmwVX82jeeuLRKKM78eBy0fQwmuCm+3J9RHUGWapQ?=
 =?us-ascii?Q?M8r5CM29qx7mKzYSkO0JslAjjowdpZeJePSpy+mtzIUfW8rABlKHeQfZkP+t?=
 =?us-ascii?Q?oVc+v83hjqdRw9hgQuh8Ctt0iWbuON+WM3DPNJTkVjkDJZdb/3W6tLnGjb0N?=
 =?us-ascii?Q?3lt0w7YC/1Nj4d5fmU18zb/ePRkkNtLZrxl7YAtKbok8l4NgVujtz0bZQdt0?=
 =?us-ascii?Q?Hxw1Se2lARTZChqTvqcbME9NM3x+TXd3DYo9bEi+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fca4c21-60f6-477b-b7c9-08db87a81cb4
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2023 16:00:31.1196
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4PRI2fiK+J0a2oyzIrrDxbgNqz+0i1pqA2EpH0zcQHJ03h2GpxxsTbstQ+/pe1Xb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7213
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 10, 2023 at 03:20:31PM -0700, Dmitry Torokhov wrote:
> kvm_vfio_group_add() creates kvg instance, links it to kv->group_list,
> and calls kvm_vfio_file_set_kvm() with kvg->file as an argument after
> dropping kv->lock. If we race group addition and deletion calls, kvg
> instance may get freed by the time we get around to calling
> kvm_vfio_file_set_kvm().
> 
> Fix this by moving call to kvm_vfio_file_set_kvm() under the protection
> of kv->lock. We already call it while holding the same lock when vfio
> group is being deleted, so it should be safe here as well.
> 
> Fixes: ba70a89f3c2a ("vfio: Change vfio_group_set_kvm() to vfio_file_set_kvm()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
>  virt/kvm/vfio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

This looks correct, I don't know of any lock cylces that could form
with kv->lock at least

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
