Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB706FD366
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 02:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235352AbjEJA7T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 20:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbjEJA7S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 20:59:18 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2069.outbound.protection.outlook.com [40.107.94.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D17D44B0;
        Tue,  9 May 2023 17:59:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nXILZlujlFQrM7HpB18nWIPGF8AnLzURplEnlnn0oOt/O/VOFjp/m0mnJafY2CTJwQuvTHXuKng12gyz/enwEhdbhgNb1/yh2txfyEcq5PWWjqPuP5vBsDBfHyZZOlOi4pz47X0NbMh2UxyjzvEJ9aG7UYtwiSo1hfsUL+OtktisqbTnWjieruONK4eqs0eecCGOEqJzQG8kQUWGs93nxix1smJb5LmV7By5AuHohfnMdx7L/Iv2HAcfIR8JaV8np5rQFbqIGg6VM/JQSrE2IA8LK75mek5fr3z6awn9hKBOI4YY0u5swkMCgGvI7cSBNCDjPiN8D80h6uvhyWAK2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oByJe20814prFskT1wFBy/Kwol7GWmfvvQPhO56YD0w=;
 b=ArHekjd6E3Pkmg9fF2562OcRwQpPHHIUXV9YDQd3lqJ5inw+2dtfogJDJfjTsAL0K1019KQwTxZw1dn1oW57V37pmfSLimXJrrLm6BdwbTosVUEKE7pN5/1GQcFiHrgWsSzJk/B10OKK2vdBoOmnxDPEyzVq1bsUhMcxoQ60eKOia3+DHjmMrzbavWIKDxi/116tYgV9P29b7Eki53zsHNUabZ1F6BrtYk8P381jvCYJUg723A5FslIdJ2rjUpfbxCmSQiNrk7lC3nb8u3L2hNCxzNZdhMLcjzVWkCgvLnhuIeqQ+EzVdE3o+25UPmpWRS9hU2KbBM57WJn+oQLAWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oByJe20814prFskT1wFBy/Kwol7GWmfvvQPhO56YD0w=;
 b=cilPS7EH8qWsWt28+HbV6G4K2HwuNbnXNiEHbVzGo8dY0575y+9Js5enb3LcpfLJL0LaqbQd0Zr0rXMAx+ovBhfvhngug7SlzgakNvqSZBqC0ch6WfraA6NW5Y++/Y2+mSugprLT3LpFkAxxEDRn+EYhu1EphnmWgHgS847c6lBjCeIr9fUHBEhalQ0HhmUTJS/SGi7K5AbwgO2T3Cdf5RazMiMPPxtBhXy6e7O75x4bNtXHZWsn7Sd3H9Sqs+2WQdhpjP53a1fyX3GB15NQpsh68mv9bA4ui64Y93d/N4ZqA9w+4MbSb69eaS1h5y7Yeg5KgbcaBk/TdG6HgVhliQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA0PR12MB8255.namprd12.prod.outlook.com (2603:10b6:208:404::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Wed, 10 May
 2023 00:59:15 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6363.032; Wed, 10 May 2023
 00:59:15 +0000
Date:   Tue, 9 May 2023 21:59:13 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "Lu, Baolu" <baolu.lu@intel.com>
Subject: Re: vPASID capability for VF
Message-ID: <ZFrsYZPRpHqVyjcZ@nvidia.com>
References: <BN9PR11MB52764BE569672A02FE2A8CCA8C769@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZFrMneCMKuCtu7JF@nvidia.com>
 <BN9PR11MB527627F407BB2942ADFF800E8C769@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZFrThMhUnsYOE3WP@nvidia.com>
 <BN9PR11MB52760816DC23D5322A4318228C769@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230509183111.6a4a7f39.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509183111.6a4a7f39.alex.williamson@redhat.com>
X-ClientProxiedBy: SJ2PR07CA0014.namprd07.prod.outlook.com
 (2603:10b6:a03:505::7) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA0PR12MB8255:EE_
X-MS-Office365-Filtering-Correlation-Id: ab25671f-1b33-47f4-22ac-08db50f1c66f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4ZcZSwy2g8/KKpf2BnPtdKchBknyXNHeaPg/bEMgn5FsgrgFzp3HAgBq9A10US38EqZtL5dHSSbACg5cpD8vRxqW9+E4HMoqv8EEvwKzfgOtuQ1pkwNHI7+LrKcsGJZZQL4ui2wFagmxl5rkvkOvacBUwQvV3xNfZI+woe/A2f4J/Ouer/9B4sGZxo8dLjXcLj6gt6dNM7lHxcco+iXV5RFhmku+UA5UmjpMAdy5ivmVl6y0kvt2pQXOnHv/M7sZnpPdJgIYssb9kiU8mIo4cx+uAeun37lHge+BOj84q1qds+voFleZFJC4SmrmgYrJaBCtWOyfzoHcf/nZ0KHYlyBgtPZB+2/2bS3fJl0eWA5MQPKsuI6UQX6dBO8UPUf/oZkyll0O5ru/Vaa/aO0XdCTUqHBZWJWyLkwnR4n8nhH8mtzylYP2AidUggqcDdtBp9JpB/Ch5yyqgzbiinl2MjgAloMwkHD1kds0+GCHXnvzkJqIKoL94EX1GuF2U7z3YqQTWwYmQ9pdaCyZ3eS6JVqZMtixFscCcUUqvLRA/Ss1rxjt0RJOUVF/gatB3Kds
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(366004)(396003)(136003)(346002)(376002)(451199021)(5660300002)(54906003)(478600001)(6486002)(41300700001)(8676002)(316002)(8936002)(6506007)(6512007)(6916009)(4326008)(66556008)(66476007)(66946007)(26005)(2906002)(4744005)(2616005)(83380400001)(186003)(3480700007)(86362001)(38100700002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CrnciYP/lqx6llyEMLLbsmA3MAbeniMlIXhOiBdbqQXYt3wghRmTSGQ9yuJq?=
 =?us-ascii?Q?v/LWoxwRgh8LOjX9hKkpqOmBFe7RygD3RCG+SrC+yn20zwPzVdHNtCSZISkt?=
 =?us-ascii?Q?fAG2GgyVSQfpmm1kHjB+r2sIn2e5PCChloc+YKh48w17epwKwCxSknvCEA/K?=
 =?us-ascii?Q?/CkufF1yu5+BVQKIzXzMInWSL5MW3GEW5yaYIzkFI965awtpNyuJa1x6+fSF?=
 =?us-ascii?Q?5fxNUsLfa7LDhco1fri86wSrse3HdlcHNqAvt5RZslV4diSLUj46jn8GCPTZ?=
 =?us-ascii?Q?vr4FP+AFlN66q0VG8EjWcoqC6HxylOpwnQ5m0SHUrEvd+9E7xv2qAozgebn3?=
 =?us-ascii?Q?Pbi+y+7FvBg0LFbegcEPbeWZS+UF23/xqvpLyqS5J7ExK/Oi178vF+BPIf4a?=
 =?us-ascii?Q?LJc5msFn9XZJCtiKLm+I98GXnv306dXiJfBthYBDmWroxALBiUX96yn+F1VZ?=
 =?us-ascii?Q?iKJ5AfHqXXiq97KfaNTZvFlJQMhLWarNq/uWj+iAUfz2VObbNgiyCCFh46SK?=
 =?us-ascii?Q?EXm5b9QQwylMRdrVoqvOTlj4LH2U5t4djpWUS3AIUH+jhqNa4XLnklh4Laa9?=
 =?us-ascii?Q?V/PZb5M3sKz4mVqnpqto4X3zf/a2kgtxMk1CQbYTJbdM9eK45GFIjeFwt4W2?=
 =?us-ascii?Q?IpA5HJiHacNHEfR6VtVUgP3jbb6Fhk00+Rs7wj1fI1Qi7hrzPmJf0hA5bLP1?=
 =?us-ascii?Q?eXtT2LUBJj/B24g/9UKQb+gnroJFJF9zH+IHy8rQ/GH+Yq3FXtmIdFnUOQrd?=
 =?us-ascii?Q?2pBzCNbEDVtESIlioz4dOq7De2siMGdXDIydP118MPOhk13cUdOkVXUhZS1A?=
 =?us-ascii?Q?qvO0APr9N8qQ62WAaOBmhgPiqNw+LluNHps4j5Q9RK7N+/0lbLvCHtLevQDm?=
 =?us-ascii?Q?42OKOUH+NzQ0tAs0y+0dU1p9OnACL/vW/sDxVMj1CsKIKjmXYwKsGh3tiU8g?=
 =?us-ascii?Q?YqYR2JR7ES5dq0TtiUTaFtVeN/A0pgen5s2f6yd4cLkafM2de9lLJuKRtSKu?=
 =?us-ascii?Q?HnZgz0M8egOtcvDSW7ERdhmNvf/K2+M8v6EAX3HdWGHpdyEiAQl3X0ZFW+uM?=
 =?us-ascii?Q?HQXwcVXOaj3RV7vkDAkCO2AHoFKp1jiXGwqHSfXlbsXvphT57N+AaVaPikEs?=
 =?us-ascii?Q?AUKw71da9Sa0PrNBWgLpp3RB2INIInTq616rqpr6UcuWRu+U/IvYucnmHjYF?=
 =?us-ascii?Q?FMsnsI6jKJZXlj1kbC+8OgyJR7K0OtM5Y+rIyXCQKLpW+jhwv9WsxihMR8Eb?=
 =?us-ascii?Q?VJyIgzN/LrETH8jlKefTdRYANAO0x2YE84+F3fagAR+nTMCG1wR9Xa1ZoTYV?=
 =?us-ascii?Q?bcXL9TjMNTfNmmlp0mCfF5Ae8VLKHHd9xHerDNQThuds7V67FAyjPuy0G71q?=
 =?us-ascii?Q?iwdHi9RDXgfp8Krd2hi3zZik2iEKlB7JgqAcbFKqp9Q2+JqY8pY5i1tvgKh2?=
 =?us-ascii?Q?LR9JmI1TR4XmIFujXl4Lnsw1MSr/SfshYLyACWddXOPXF2LIFhDAXjWnTBOm?=
 =?us-ascii?Q?6ThB3RZn4gDPEOFXGe1vp5tXYWRfLBv0KOcWTixHngse0C31bcIBGu5+f1je?=
 =?us-ascii?Q?Z4P2M9ndXE4nSQ11f6/BxcL7NiQ69oEbvYCmzg/3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab25671f-1b33-47f4-22ac-08db50f1c66f
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 00:59:15.0835
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o1AAmSsnD8pS2PS1hMrLsSQsObDKUnQAG+BV9FO6qkrQeQAaxCm3CjNNLIMJhp+S
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8255
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 09, 2023 at 06:31:11PM -0600, Alex Williamson wrote:

> IIRC we originally needed to enable this for a Broadcom NIC that
> stuffed device specific registers in un-architected config space. The
> capabilities we're {un}hiding are architected things that we know are
> unsupported or unsafe, the gaps, just like device specific
> capabilities, we're obliged to expose for functionality.  Thanks,

I still think that if people want to do this they should wrap their
stuff in a dvsec..

If we have no choice but to inject a PASID cap for this to work then I
don't think we should quirk every device, but punish those that don't
use DVSEC/etc

So.. If PASID injection is needed then block the unmanaged space and
add quirks for devices that really need it. Otherwise leave it
alone.

Jason
