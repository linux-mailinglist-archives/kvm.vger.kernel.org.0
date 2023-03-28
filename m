Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9F076CC9AA
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 19:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbjC1Rvy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 13:51:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbjC1Rvu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 13:51:50 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60B3DD318;
        Tue, 28 Mar 2023 10:51:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SuNhtdxrp1zZvtA16yFV5VvcUUOM8V9QJfNVpV0gtu4GLOppLtWEcJiDMYmKQzJ2uKXs8V9jH1IpJDvETdMoXL9ZlK/5wrZJOx2r0C3OaQYKKbAC9tZhhtQgycMmgA22dcMImQxoLs0xS5+8sYY/IBAshhoj4nNqYqv7k0/4Qp4Oa+FKhsFdrAR6gldsFmDwWJbr6bH448EpdqylZK+bUdOa5I2Brl75JoZ5kLalLh76Rck8rA/DNCxMFHKO3S2TMxgkd7PSHt/Sr718dlN+zCpPKgYNW1LlfovV//Spl8ES/qgwXdhkDohnS9FTLpRtjdZzm40I9VbAYnjDhXd6mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vyLOsbBdx+n2c7+cKkM6L8+3Dk9+oyJzJG2Ifalsy3A=;
 b=EdXSw22wFS1D59eZZsTNTp32xznKsyGx9EvgwSYYeSfr/ueEoq6wkXBJOVtLj+er3ioySSp2sSkLuDC+z4EH+r8Okus3DcFbem8tSmHD/qmptv2uv3PS3XRoOIlw6hbb/PyN6ciQxXO/E3/l1DvzHuIailrg6amuRux31ULhtOS6ejOjvfarJrNIwzhgXJcQIDr92lzE5aESyg/yegj246wMIOh8W7UFPmKeL3qS6JMexAVs34oGqYLuUO/ZOJBcBMZ3/1w/NzuC+zUIYMky6X/gYcO4SN/JZk3VXvfsE7lR4qHCnXXrwi7F4ZjWsynFnuENAamU5sRWMIuJPU3ifg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vyLOsbBdx+n2c7+cKkM6L8+3Dk9+oyJzJG2Ifalsy3A=;
 b=ITmBJtDa6reCtytGmAdg/m2T8+4UO3wsl/ydRv+k7WsbGZrFlxvvEzJ/9dXpRwvRqBgQ285ekUufdU6vnVvL3V44AMzPo+dt1tg+MXoHaca35lL7ybMauMBKkW1bPiwN0Kk1Xo/yCWP7oszfnv7n2FlflR7zTAd8iaT4kVN3cPk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20)
 by DS0PR12MB6629.namprd12.prod.outlook.com (2603:10b6:8:d3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.30; Tue, 28 Mar
 2023 17:51:42 +0000
Received: from BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::de95:3582:8274:ff60]) by BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::de95:3582:8274:ff60%3]) with mapi id 15.20.6178.041; Tue, 28 Mar 2023
 17:51:42 +0000
Date:   Tue, 28 Mar 2023 12:51:32 -0500
From:   John Allen <john.allen@amd.com>
To:     "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Yang, Weijiang" <weijiang.yang@intel.com>,
        "Christopherson, Sean" <seanjc@google.com>
Cc:     "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, Borislav Petkov <bp@alien8.de>
Subject: Re: [RFC PATCH 0/7] SVM guest shadow stack support
Message-ID: <ZCMpJLAx8//1zLLV@johallen-workstation.lan>
References: <20221012203910.204793-1-john.allen@amd.com>
 <Y9B97dZnFnjEHhVf@google.com>
 <d4e15021af4e72d6daba4021feaebf289b676830.camel@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4e15021af4e72d6daba4021feaebf289b676830.camel@intel.com>
X-ClientProxiedBy: MW4PR04CA0159.namprd04.prod.outlook.com
 (2603:10b6:303:85::14) To BL1PR12MB5995.namprd12.prod.outlook.com
 (2603:10b6:208:39b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5995:EE_|DS0PR12MB6629:EE_
X-MS-Office365-Filtering-Correlation-Id: fa613be0-fc88-4dfa-29e8-08db2fb51698
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7cc8t3u8S2jHB1fGmwmC+SNZxlka/QzAYtkDzcSwFDXAiIf6f0S53cBQ+keBLYCmexmJ9jhIx9aXze5HHomYpyAxhsKwVi5QPCLXRCKPfp26yvEDd17/Mgr4oMZzA6kXP/OHlSmJln2/BEvBNfcnMT+3/8UA6fPaKR0976GaybmbUSByN7cKUHqJTq6O21pKyoKbJNcwuYhEqv3UPJFJxUvLbHEYdV1oqZAJcM/stGFl5d+N6MP4QqWCZsFUAbKLZlNVsjj1SunE2OhHJ9IZQ2Dz4r1s4KOiVy8GReT1y/5rI3Z1E6xgLyBbzzGZXbOqggCpZS8N1zf36k9vtemu+oCF0Ste4vAjFTFGJWtO0+hdtQjThZWVTLsacaCf2gAJIi5ONUtHZqJ7M82/bIUQj/BL6hOCymmfsd/sFC4srB6/iqPfGaDvJHnnHdErO4Tb6p/uKtKTlBvSqFP/gCSsDUDLEKqcMINVXeaJ4YBKwdzkOf4nXMGj1GFhWdqbgMete37PbFnMTTx1nA312VctYz3vVquQRVDNLAugx7QpVl0eU59WDToL9Ylu9x0e2LToOFFYshSc3gF+yyCYJVBmCA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(366004)(39860400002)(396003)(136003)(451199021)(4326008)(66476007)(66556008)(66946007)(316002)(478600001)(8676002)(54906003)(38100700002)(110136005)(2906002)(186003)(6506007)(26005)(6512007)(44832011)(83380400001)(9686003)(36756003)(86362001)(5660300002)(6666004)(41300700001)(6486002)(966005)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WNBfftUzTKiYuD1XTJr0VhRCTKRnZ7wTNYuz+p19HKElDBcVe96yub0DiA16?=
 =?us-ascii?Q?7SaH9CkzK2MVqPSAkoZqUMbfCl4dz+f9NNcOJFa1grWGE/qohl+pJLcj1aZ0?=
 =?us-ascii?Q?xPzicCSiVGs4aPPU+tqAdAtogeIv4xbQs1wjCr1YvTcvZ17L8keUSul4MGPL?=
 =?us-ascii?Q?xb5a+QS9vU5cbi25XyfUZ0XEAljUg8xWNbNrn1KTH6x98XBJPFl4s7HnfpjO?=
 =?us-ascii?Q?8rLJNO7apo8x1ISl8bUsTeNQ8wo4fXbxkVPNvE127SHFEN8II9I+23VDXm7T?=
 =?us-ascii?Q?8kY07KFVo1t+ZZLx9RaTjMl9gYeo6lleP/YP1giIccBCQK93POt1oofUP8RV?=
 =?us-ascii?Q?rQxFcM/NCxTP+FCcD5zTVjnGAV2QR7rJ/pW+2F7r3MEc40S+EtRAXYxQPaUs?=
 =?us-ascii?Q?FjJ7/0y7LvdDxFCQp+R78eCpcgRE8Ss+q0h/OR538aX8ZsmPrnBesDJt6v24?=
 =?us-ascii?Q?85XfDz2/rjuTUZRpOy552tIYA+YzOI5co5AIhZL9mADtGiOxyi1Va+6NFUks?=
 =?us-ascii?Q?pWZj54rfcBALrnwPhveyOUytjDq84m8pnMqj98nsOWfnXjChrG/kmyEJ/mQ3?=
 =?us-ascii?Q?lTrCpHpmXA+aoEQ7pIWwiG+QltHtoOYm60VAaZSu53dRxUM7GHdgxHgM2Tze?=
 =?us-ascii?Q?Rjo+0xwY2tEYPrVVRpvvMZA0Az841+4kTlahnx0je0z6yR3wjL+WUMg6pZvS?=
 =?us-ascii?Q?P2DJGoBUCUo3+hy6fBHp6yZy6V10BHBewb81e0RVljw9xXbIWkLpobqagps8?=
 =?us-ascii?Q?TH/5V+spIms/V93nezAZX+GdjjH/iIscmaKFs6aLO0duoTZX8V9LERKztQ+p?=
 =?us-ascii?Q?CnJJXKJtkBTpGt8ulNZH3EzK884EuGZIqYclWYgoPaEGv9a89WXNRtbUmF5N?=
 =?us-ascii?Q?MmXeZeL5jKMeBPzFh+V8Eb33xH7sXDS81hb+LqpYZNHL5EJmlyVIzpmrYDfG?=
 =?us-ascii?Q?0IAi0kgp54RQkQAI6xYmEvbrBJtfDudMy1hRZzM4Mn6rOpZdPjDyVYcShSc1?=
 =?us-ascii?Q?5U11jReIMeHdhUnosGj/qgX7qPwiuVZvcM/wtcCSF5Y+UYfsRyfeORIOnjcQ?=
 =?us-ascii?Q?bkl/p7XV7gclfQJnj8TiZtDYZwAW85M3aOXcZ10DsyouOEULoTiKUasYevbO?=
 =?us-ascii?Q?qRmB3/dAbUHXtqDHull+DlN8AEPASRtrbP9fq6kb+UHcl3NaDDRnhJPcZ22n?=
 =?us-ascii?Q?wD2MTCd3IVr2hJHcWarc0nTuUoOshwtLzO/vZOmBXraEonchRlxTHAS+CHD1?=
 =?us-ascii?Q?j+5KIrLk4d0BfybNaEWruayLfuuC1j6ZOjeiZcBC9hVlhO5fx80Maf68g9EK?=
 =?us-ascii?Q?0byuqOkyKXBnNiIPwIFZ5XSt/0uxUcx5HEt/p44fG4y+psFfU6yET6UL/iOz?=
 =?us-ascii?Q?JN3vcb8EMuSQtHwjjQzDgUTPgJtMsGEiTtA/IhkeIA1Gx8cBvR+NZxOF8YZh?=
 =?us-ascii?Q?cmkd2QgNA85UHn0A/tJf/+2EPdn868dyIKtbezI/nERRv9NEi926RGf/+XfN?=
 =?us-ascii?Q?7sMsGr49SpMPwgNZr/s/Gxt+XrCWTh9eUv+aqFAwYrq5GV6cTYolyYaWjIHK?=
 =?us-ascii?Q?2rMdELleG/1fJMq/6vSCpDphely52Zp8QIfQ8qxv?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa613be0-fc88-4dfa-29e8-08db2fb51698
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5995.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 17:51:41.9901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NvVDCY+8iVP1jlc57iBUMPjEjjE6L5eVaySV0lTjSVd2XJE8V4EF48KSn8kPTbZc1BFAzSoHmTbUDBfX8qdVNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6629
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 25, 2023 at 01:11:44AM +0000, Edgecombe, Rick P wrote:
> On Wed, 2023-01-25 at 00:55 +0000, Sean Christopherson wrote:
> > On Wed, Oct 12, 2022, John Allen wrote:
> > > AMD Zen3 and newer processors support shadow stack, a feature
> > > designed to
> > > protect against ROP (return-oriented programming) attacks in which
> > > an attacker
> > > manipulates return addresses on the call stack in order to execute
> > > arbitrary
> > > code. To prevent this, shadow stacks can be allocated that are only
> > > used by
> > > control transfer and return instructions. When a CALL instruction
> > > is issued, it
> > > writes the return address to both the program stack and the shadow
> > > stack. When
> > > the subsequent RET instruction is issued, it pops the return
> > > address from both
> > > stacks and compares them. If the addresses don't match, a control-
> > > protection
> > > exception is raised.
> > > 
> > > Shadow stack and a related feature, Indirect Branch Tracking (IBT),
> > > are
> > > collectively referred to as Control-flow Enforcement Technology
> > > (CET). However,
> > > current AMD processors only support shadow stack and not IBT.
> > > 
> > > This series adds support for shadow stack in SVM guests and builds
> > > upon the
> > > support added in the CET guest support patch series [1] and the CET
> > > kernel
> > > patch series [2]. Additional patches are required to support shadow
> > > stack
> > > enabled guests in qemu [3] and glibc [4].
> > > 
> > > [1]: CET guest support patches
> > > 
> https://lore.kernel.org/all/20220616084643.19564-1-weijiang.yang@intel.com/
> > > 
> > > [2]: Latest CET kernel patches
> > > 
> https://lore.kernel.org/all/20220929222936.14584-1-rick.p.edgecombe@intel.com/
> > 
> > That dependency chain makes me sad.
> > 
> > Outside of a very shallow comment on the last patch, I don't plan on
> > reviewing
> > this until the kernel side of things gets out of our way.  When that
> > finally
> > does happen, I'll definitely prioritize reviewing and merging this
> > and the KVM
> > Intel series.  I'd love to see this land.
> 
> I think all KVM needs is a few patches from the beginning of the host
> series (the FPU stuff). At one point Weijiang and I had discussed with
> Paolo and x86 folks that those few could go up with the KVM series if
> desired.

Now that the baremetal series has been accepted, how do we want to
proceed? I think I'd like to send a refreshed version based on the
version that was accpeted, but I'd want to wait to base it on a new
version of Weijiang's kvm/vmx series (if one is planned).

Weijiang and Rick,

Are you planning on sending a new version of the kvm/vmx series?

Thanks,
John
