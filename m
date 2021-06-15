Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E14133A8C88
	for <lists+kvm@lfdr.de>; Wed, 16 Jun 2021 01:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbhFOXfF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 19:35:05 -0400
Received: from mail-bn7nam10on2084.outbound.protection.outlook.com ([40.107.92.84]:18400
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229898AbhFOXfE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Jun 2021 19:35:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lMmw30HvcOSN42v8eymyQ6G6oIDrBk+9kqx0kA8bPspuVPeGHIV07ULmgYJeoBilat0SNOvzeRu1M8rmtyu4dZY+wahckC9FoRC1c1nv2vBolvr2SZ+tEEvScDvEXTZS7NL2yRwo04fMszVUc9CS2cq/pRd0mz0BvHW2zkTPsf6A7GUuBh5756JrkybyDYE0cW5StlPHMqIn7VBRUFS49+wURFgsfZu/K5Limyn9jbqcxdHDKZDXYy8kjmIIvkARDT1nHGnbevQLfmSE7ulO5RIV27ef7OKbynqe47T1Nj4VHzqWD4ukbaVKUcF2meAHvbXiRohgmFxZtKEmOd+e8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1vRs3DF6cs3k9BGmQL+VwHwdiPIEgI1HYX6iaWH6lvI=;
 b=U3EXy7DAdVViLkYc0Gz3Iq/eWSbSHS6gOvPbGrAiX18DwtMk9gxsCP6bDxr5VgfuYAbhylHmpss3S1WkXvki3ZIs8+g32e5ik7kCRxxbHd84n2RaWGubg7nLnBwHgDHf+/KMS0FOfne7IZS6ozF8tGj80T1i6VPIGaGO5UQd/m3h3PBAn+IK0dnsYxu3cBGUIarlhGl1ldlmEShpSMGx7k5CWCNZ/2lyA1f/a+q/gHkqkFGWDtwjc0C56iaS1nIV44GdHWDCVNzFkcdqMgFfvQo8OFMcwvybEZkTXPAksi7Zvcw0mJWJX6xiaKUTO0U2N2C2cHA3fz8cM0VaV9FSpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1vRs3DF6cs3k9BGmQL+VwHwdiPIEgI1HYX6iaWH6lvI=;
 b=GVhDdpw8F/W6D2MM7jP0qtyfksEHOoXs5g6EX+4HmXOb7Woc9sjIB3TmIhPGMagZ+Kn5pteVhXe5ZjlcniCbqrFc/fcig7vaiE1iiZR5eMr3xsmSlVC19Wk25OSlYklKcS9sDSqY7o7zglDPJaZB4jIard4SR9dm1TE0z60qcCISjcVIbblqBqjwrpeGclM9UpFyp1VjXh/ws8LZu9sIbSAEvCmd8btwgldeHT/n46qEz8rszAAfir7yViX73v3WRjTQZ9uEVpdNgL4KlVZHOe55yA8i5ZAjWhzmQIzt2Expw0sPb79uXHb41AVxaUS9LeYdgABYt5hc+48lc43msw==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5128.namprd12.prod.outlook.com (2603:10b6:208:316::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15; Tue, 15 Jun
 2021 23:32:58 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%8]) with mapi id 15.20.4242.016; Tue, 15 Jun 2021
 23:32:58 +0000
Date:   Tue, 15 Jun 2021 20:32:57 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Max Gurtovoy <mgurtovoy@nvidia.com>, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        aviadye@nvidia.com, oren@nvidia.com, shahafs@nvidia.com,
        parav@nvidia.com, artemp@nvidia.com, kwankhede@nvidia.com,
        ACurrid@nvidia.com, cjia@nvidia.com, yishaih@nvidia.com,
        kevin.tian@intel.com, hch@infradead.org, targupta@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, liulongfang@huawei.com,
        yan.y.zhao@intel.com
Subject: Re: [PATCH 09/11] PCI: add matching checks for driver_override
 binding
Message-ID: <20210615233257.GB1002214@nvidia.com>
References: <117a5e68-d16e-c146-6d37-fcbfe49cb4f8@nvidia.com>
 <20210614124250.0d32537c.alex.williamson@redhat.com>
 <70a1b23f-764d-8b3e-91a4-bf5d67ac9f1f@nvidia.com>
 <20210615090029.41849d7a.alex.williamson@redhat.com>
 <20210615150458.GR1002214@nvidia.com>
 <20210615102049.71a3c125.alex.williamson@redhat.com>
 <20210615204216.GY1002214@nvidia.com>
 <20210615155900.51f09c15.alex.williamson@redhat.com>
 <20210615230017.GZ1002214@nvidia.com>
 <20210615172242.4b2be854.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210615172242.4b2be854.alex.williamson@redhat.com>
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: CH2PR19CA0001.namprd19.prod.outlook.com
 (2603:10b6:610:4d::11) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by CH2PR19CA0001.namprd19.prod.outlook.com (2603:10b6:610:4d::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16 via Frontend Transport; Tue, 15 Jun 2021 23:32:58 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1ltIYD-007Ga6-50; Tue, 15 Jun 2021 20:32:57 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c3946069-87b5-4407-2127-08d93055e8af
X-MS-TrafficTypeDiagnostic: BL1PR12MB5128:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5128070FF6185F46A0657A1AC2309@BL1PR12MB5128.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vurOd9v1+fNyFtECryLqQQuVKL/7VQBVc7AFRK19vaQ1G3TbCxnVm5K8M9S8VjHzKceVI1LrpelDY0FCavrPwHEeaE+qPEsJ8lA79s5Q5ppqbyog9+0J6otrFUKBmtSECd7PstArbJTN5kLH4kKdzWP4a4ygyiufIKEMFa4a3lmHlo5cmJVUxh1C81GF6xOn+9DUpiWizJ68coOcNcI5Jbnqn3jF1s0SjoQPgoAQLu5451d34R7xB7skmzV4zqpKTvLHZQnHCjTJrR5MPgmyNa0BZdfUcxnr6jvt3yol0/xgxlFqI7tIP07aPsmVTOFP+CLJgIDsuPdirYZvByy/QdevL6q0l0uID9dl4v/C+ZNnybudRhsyB9it+lxSZNP8sDhgWHbK92JwOCdw23jAClL7LO48MgLtQchv7Ev8XR5MlRLmjL4h/XBRUF6I1DcVWJ5xYi/zc4yCwyEjTEXqDDz1zNbn/fTJzAH8ZTdkxjvi/HrHtLASX/opP6P+KwtUNaILCLXtI0nkjRTlfnAC4t+P2VSpANaS3od/oeNgbXuHs542IV9CLJ2U+rV/4mxG21bPKvATlN+Jb3e4j5T2G5w6Gk4lhFXFuC74b17wInk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(366004)(376002)(136003)(396003)(5660300002)(83380400001)(38100700002)(2906002)(9786002)(66476007)(66556008)(66946007)(9746002)(6916009)(4326008)(86362001)(316002)(26005)(478600001)(8936002)(8676002)(1076003)(186003)(33656002)(36756003)(2616005)(426003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?r0gy0JppyKKKBTsJLo6WIi0jiEybqJN0RdB5C0+QgSko5EF0TiwvCbbwcc0A?=
 =?us-ascii?Q?WyuSQE2F96FByatmVaGyMnFXS0dvhqeiH7nGYlSGeGCj7YQMvGUXEZaa1rj4?=
 =?us-ascii?Q?Kkn8Sg9vRLzy/tGxGSHOQiNptEyMZY7BWLDQJqntB1hBm9b4CXY0jOB/SASt?=
 =?us-ascii?Q?MUT1R3gq73ueJQM7r5Y6ptKdVFebzeD6Curep0W7MxY7lYJIUl2Z1k5WZVuZ?=
 =?us-ascii?Q?/kZFR2YOXydHFe/vmZJA4o2aTzEMYr7QiWg8sgpFb5qtUvB49YwuJbWN7LiJ?=
 =?us-ascii?Q?EW19rrEqZgLg0cjIvFtGzDWyFDVcf56AyK8eLav/6RGy/nde0qVUlgAgu/HF?=
 =?us-ascii?Q?jEBUO945dhC/TZl+d5I2qyt9QjnUmVjXX7+macn2ay5EXILNi7vuIIX2zi4/?=
 =?us-ascii?Q?sVupd5joLtss1kaUXz9RM7u2xRu0t5aCgJjyIX0DTBxcXZRSkidYRgSAhpvR?=
 =?us-ascii?Q?SH0AicLNRKHSO9ySnoFddRRVjAbLTVoDP139oR/lDOCVmE8NylCPxpWjLAEZ?=
 =?us-ascii?Q?RybU/gYeZr8YdI/QCNCEhzoqZRWwDBpG1tdufS09SioBTg+btK7Kix5r3uEp?=
 =?us-ascii?Q?2A+HvKgqROn2vyvwu0EIbV/bboXK1+gK4tkhxsmB8dvTuMwbPVLGSHylF4fm?=
 =?us-ascii?Q?2rcscfUQw8XD+G5kFTnSuqEpsFrPgmxiSbje8djpKOzwtF3k5CXX5azVYP28?=
 =?us-ascii?Q?EMdnczi3OYHCb/jWpzOMmrh0/tCThj9DVvXICMii2ZkybUZjIpDjW6qPMbjw?=
 =?us-ascii?Q?lNlDYcQQQ6BpI8p3ApP8J5vjAY6MUf7Wc0ihCL5qjFNDrXy1Z65b3enh5f5a?=
 =?us-ascii?Q?FvxUioFYIJQQX5cwIU2O2JNZnRp7KHA7U9sRa0W4rDS2MdXsojKDq9wlo7kz?=
 =?us-ascii?Q?bAbX9bRfHmRDz3Oew8GAaykvpHc9pBgOcBUQb3H17yJSs9y7Kbrzjboolco2?=
 =?us-ascii?Q?zOnTMTDcvQgF+Pe5ehH3odGW/d+UNhFvNr2OrN3XQTlhcWLs+2vIXFQQEc3K?=
 =?us-ascii?Q?YviE6XCBG6fUffmrdhGWSnc8nN3NgRLeZVQFyzqUBUUgMcj4NvzmnxwAyc/o?=
 =?us-ascii?Q?hvUXlve0CWmOxvdvXuMKfyxXl8+tyLycWbryilSASf4wx3uEykb5Snv5X1VF?=
 =?us-ascii?Q?vCd6+9vE7dGwGlijPqmk7H3Ml1xELEmhWx+EHnkOe8QTDpFrrMDtMx4P5tWe?=
 =?us-ascii?Q?wilN8ENEXs/s6dGAFhNg3xu1pob2qATX2x3H+X6qWaEOXix2o4mG99o9v9Rd?=
 =?us-ascii?Q?BW1713SGEsgZnlcc7Je4ov/03yVmQFMFfPC1NWXbTA9nAZcdEIuPjlxHTwtp?=
 =?us-ascii?Q?RHLv8IKZvdhKjCG4xFfcXtVk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3946069-87b5-4407-2127-08d93055e8af
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2021 23:32:58.5303
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /O2nBDwLItBdyFk0591O3L31ZDnxGg14Rk5P9utMqYrhx++BpyQoh5K6lMs3eoGi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5128
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 15, 2021 at 05:22:42PM -0600, Alex Williamson wrote:

> > > b) alone is a functional, runtime difference.  
> > 
> > I would state b) differently:
> > 
> > b) Ignore the driver-override-only match entries in the ID table.
> 
> No, pci_match_device() returns NULL if a match is found that is marked
> driver-override-only and a driver_override is not specified.  That's
> the same as no match at all.  We don't then go on to search past that
> match in the table, we fail to bind the driver.  That's effectively an
> anti-match when there's no driver_override on the device.

anti-match isn't the intention. The deployment will have match tables
where all entires are either flags=0 or are driver-override-only.

I would say that mixed match tables make driver-override-only into an
anti-match is actually a minor bug in the patch.

The series isn't about adding some new anti-match scheme.

> I understand that's not your intended use case, but I think this allows
> that and justifies handling a dynamic ID the same as a static ID.
> Adding a field to pci_device_id, which is otherwise able to be fully
> specified via new_id, except for this field, feels like a bug.  Thanks,

Okay, I see what you are saying clearly now.

Your example usage seems legit to me, but I really don't want to
entangle it with this series. It is a seperate idea, it can go as a
seperate work that uses the new flags and an updated new_id and
related parts by someone who wants it.

I hope you'll understand that having NVIDIA Mellanox persue what you
describe above is just not going to work..

Jason
